package AI::TensorFlow::Libtensorflow::Lib::FFIType::TFOutputArrayPtr;
# ABSTRACT: Packs TF_Output array using ::Record

use FFI::Platypus;
use FFI::Platypus::API qw(
  arguments_set_pointer
);
use FFI::Platypus::Buffer qw( scalar_to_buffer buffer_to_scalar );

my @stack;

sub perl_to_native {
	my @args = @_;
	my $data = pack "(a*)*", map $$_, @{$_[0]};
	my($pointer, $size) = scalar_to_buffer($data);
	my $n = @{$_[0]};
	my $sizeof = $size / $n;
	push @stack, [ \$data, $n, $pointer, $size , $sizeof ];
	arguments_set_pointer $_[1], $pointer;
}

sub perl_to_native_post {
	my($data_ref, $n, $pointer, $size, $sizeof) = @{ pop @stack };
	$$data_ref = buffer_to_scalar($pointer, $size);
	@{$_[0]} = map {
		bless \$_, 'AI::TensorFlow::Libtensorflow::Output'
	} unpack  "(a${sizeof})*", $$data_ref;
	();
}

sub ffi_custom_type_api_1
{
	{
		native_type         => 'opaque',
		perl_to_native      => \&perl_to_native,
		perl_to_native_post => \&perl_to_native_post,
		argument_count      => 1,
	}
}

1;
