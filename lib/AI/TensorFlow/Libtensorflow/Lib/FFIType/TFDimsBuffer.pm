package AI::TensorFlow::Libtensorflow::Lib::FFIType::TFDimsBuffer;
# ABSTRACT: Type to hold dimensions array and number of dimensions

use FFI::Platypus::Buffer qw(scalar_to_buffer buffer_to_scalar);
use FFI::Platypus::API qw( arguments_set_pointer arguments_set_sint32 );

# Dims: int64_t[] + int

my @stack;

sub perl_to_native {
	my ($value, $i) = @_;
	# q = signed 64-bit int (quad)
	my $dims_data = pack 'q*', @$value;
	my $ndims     = scalar @$value;
	my ($pointer, $size) = scalar_to_buffer($dims_data);

	push @stack, [ \$dims_data, $pointer, $size ];
	arguments_set_pointer( $i  , $pointer);
	arguments_set_sint32(  $i+1, $ndims);
}

sub perl_to_native_post {
	pop @stack;
	();
}

sub ffi_custom_type_api_1 {
	{
		'native_type' => 'opaque',
		'perl_to_native' => \&perl_to_native,
		'perl_to_native_post' => \&perl_to_native_post,
		argument_count => 2,
	}
}

1;
