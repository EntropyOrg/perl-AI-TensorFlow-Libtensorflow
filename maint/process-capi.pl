#!/usr/bin/env perl
# PODNAME: gen-capi-docs
# ABSTRACT: Generates POD for C API docs

package TF::CAPI::Extract {
	use FindBin;
	use lib "$FindBin::Bin/../lib";

	use Mu;
	use CLI::Osprey;

	use feature qw(say postderef);
	use Syntax::Construct qw(heredoc-indent);
	use Function::Parameters;

	use Path::Tiny;
	use Types::Path::Tiny qw/Path/;
	use File::Find::Rule;

	use Sort::Key::Multi qw(iikeysort);
	use List::Util qw(uniq);
	use List::SomeUtils qw(firstidx part);

	use Module::Runtime qw(module_notional_filename);

	option 'root_path' => (
		is => 'ro',
		format => 's',
		doc => 'Root for TensorFlow',
		default => "$FindBin::Bin/../../tensorflow/tensorflow",
		isa => Path,
		coerce => 1,
	);

	option 'lib_path' => (
		is => 'ro',
		format => 's',
		doc => 'Root for lib',
		default => "$FindBin::Bin/../lib",
		isa => Path,
		coerce => 1,
	);


	lazy capi_path => method() {
		$self->root_path->child(qw(tensorflow c));
	};

	lazy header_paths => method() {
		[ map path($_), File::Find::Rule->file
			->name('*.h')
			->in( $self->capi_path ) ];
	};

	lazy header_order => method() {
		my @order = (
			qr{/c/c_api.h$},
			qr{/c/tf_[^.]+\.h$},
			qr{/c/(ops|env|logging)\.h},
			qr{kernels},
			qr{/eager/},
			qr{/experimental/},
			qr{.*},
		);
		\@order;
	};

	lazy fdecl_re => method() {
		my $re = qr{
			(?>
				(?<comment>
					(?: // [^\n]*+ \n )*+
				)
			)
			(?<fdecl>
				^ TF_CAPI_EXPORT [^;]+ ;
			)
		}xm;
	};

	lazy sorted_header_paths => method() {
		my @order = $self->header_order->@*;
		my @sorted = iikeysort {
				my $item = $_;
				my $first = firstidx { $item =~ $_ } @order;
				($first, length $_);
			} $self->header_paths->@*;
		\@sorted;
	};

	method _process_re($re) {
		my @data;
		my @sorted = $self->sorted_header_paths->@*;
		for my $file (@sorted) {
			my $txt = $file->slurp_utf8;
			while( $txt =~ /$re/g ) {
				push @data, {
					%+,
					file => $file->relative($self->root_path),
					pos  => pos($txt),
				};
			}
		}
		\@data;
	}

	lazy fdecl_data => method() {
		my $re = $self->fdecl_re;
		$self->_process_re($re);
	};

	method generate_capi_funcs() {
		my $pod = '';

		my @data = $self->fdecl_data->@*;
		# Used for defensive assertion:
		# These are mostly constructors that return a value
		# (i.e., not void) but also take a function pointer as a
		# parameter.
		my %TF_func_ptr = map { ($_ => 1) } qw(
			TF_NewTensor
			TF_StartThread
			TF_NewKernelBuilder
			TFE_NewTensorHandleFromDeviceMemory
		);

		for my $data (@data) {
			if( $data->{fdecl} =~ /TF_Version/ ) {
				$data->{comment} =~ s,^// -+$,,m;
			}

			my @tags;
			push @tags, 'experimental' if( $data->{file} =~ /experimental/ );
			push @tags, 'eager' if( $data->{file} =~ /\beager\b/ );

			my $text_decomment = $data->{comment} =~ s,^//(?: |$),,mgr;
			$text_decomment =~ s,\A\n+,,sg;
			$text_decomment =~ s,\n+\Z,,sg;

			my ($func_name) = $data->{fdecl} =~ m/ \A [^(]*? (\w+) \s* \( (?!\s*\*) /xs;
			die "Could not extract function name" unless $func_name;

			# defensive assertion for parsing
			my $paren_count = () = $data->{fdecl} =~ /[\(]/sg;
			warn "Got $func_name, but more than one open parenthesis [(] in\n@{[ $data->{fdecl} =~ s/^/  /gr ]}\n"
				if(
					$paren_count != 1
					&& !(
						$data->{fdecl} =~ /^ TF_CAPI_EXPORT \s+ extern \s+ void \s+ \Q@{[ $func_name ]}\E \s* \(/xs
						||
						exists $TF_func_ptr{$func_name}
					)
				);

			my $comment_pod = <<~EOF;
			=over 2

			@{[ $text_decomment =~ s/^/  /mgr ]}

			=back

			EOF

			my $code_pod = <<~CODE =~ s/^/  /mgr;
			/* From <@{[ $data->{file} ]}> */
			@{[ $data->{fdecl} ]}
			CODE

			my $func_pod = <<~EOF;

			=head2 @{[ $func_name ]}

			$comment_pod

			$code_pod

			EOF

			$pod .= $func_pod;
		}

		my $doc_name = 'AI::TensorFlow::Libtensorflow::Manual::CAPI';
		substr($pod, 0, 0) = <<~EOF;
		# PODNAME: $doc_name

		=pod

		=encoding UTF-8

		=for Pod::Coverage

		=cut

		=head1 DESCRIPTION

		The following a list of functions exported by the TensorFlow C API with their
		associated documentation from the upstream TensorFlow project. It has been
		converted to POD for easy reference.

		=head1 FUNCTIONS

		EOF

		$pod .= <<~EOF;

		=head1 SEE ALSO

		L<https://github.com/tensorflow/tensorflow/tree/master/tensorflow/c>

		=cut

		EOF

		my $output = $self->lib_path->child(module_notional_filename($doc_name) =~ s/\.pm$/.pod/r );
		$output->parent->mkpath;
		$output->spew_utf8($pod);
	}

	lazy typedef_struct_data => method() {
		my $re = qr{
			(?<opaque>
				^
				typedef      \s+
				struct       \s+
				(?<name>\w+) \s+
				\k<name>     \s*
				;
			)
			|
			(?<transparent>
				^
				typedef      \s+
				struct       \s+
				(?<name>\w+) \s+
				\{
				[^\}]+
				\}           \s+
				\k<name>     \s*
				;
			)
		}xm;
		$self->_process_re($re);
	};

	method check_types() {
		my @data = $self->typedef_struct_data->@*;
		require AI::TensorFlow::Libtensorflow;
		require AI::TensorFlow::Libtensorflow::Lib;
		my %types = map { $_ => 1 } AI::TensorFlow::Libtensorflow::Lib->ffi->types;
		my %part;
		@part{qw(todo done)} = part { exists $types{$_} } uniq map { $_->{name} } @data;
		use DDP; p %part;
	}

	method run() {
		$self->generate_capi_funcs;
		$self->check_types;
	}
}

TF::CAPI::Extract->new_with_options->run;
