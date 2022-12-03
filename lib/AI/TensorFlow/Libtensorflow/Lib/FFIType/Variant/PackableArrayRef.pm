package AI::TensorFlow::Libtensorflow::Lib::FFIType::Variant::PackableArrayRef;
# ABSTRACT: ArrayRef to pack()'ed scalar argument with size argument (as int)

use FFI::Platypus::Buffer qw(scalar_to_buffer);
use FFI::Platypus::API qw( arguments_set_pointer arguments_set_sint32 );

use Package::Variant;
use Module::Runtime 'module_notional_filename';

sub make_variant {
	my ($class, $target_package, $package, %arguments) = @_;

	die "Invalid pack type, must be single character"
		unless $arguments{pack_type} =~ /^.$/;

	my @stack;

	my $perl_to_native = install perl_to_native => sub {
		my ($value, $i) = @_;
		# q = signed 64-bit int (quad)
		my $data = pack  $arguments{pack_type} . '*', @$value;
		my $n    = scalar @$value;
		my ($pointer, $size) = scalar_to_buffer($data);

		push @stack, [ \$data, $pointer, $size ];
		arguments_set_pointer( $i  , $pointer);
		arguments_set_sint32(  $i+1, $n);
	};

	my $perl_to_native_post = install perl_to_native_post => sub {
		pop @stack;
		();
	};
	install ffi_custom_type_api_1 => sub {
		{
			native_type => 'opaque',
			argument_count => 2,
			perl_to_native => $perl_to_native,
			perl_to_native_post => $perl_to_native_post,
		}
	};
}

sub make_variant_package_name {
	my ($class, $package, %arguments) = @_;
	$package = "AI::TensorFlow::Libtensorflow::Lib::FFIType::TF${package}";
	die "Won't clobber $package" if $INC{module_notional_filename $package};
	return $package;
}

1;