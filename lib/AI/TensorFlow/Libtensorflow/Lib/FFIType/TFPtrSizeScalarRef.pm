package AI::TensorFlow::Libtensorflow::Lib::FFIType::TFPtrSizeScalarRef;
# ABSTRACT: Type to hold pointer and size in a scalar reference

use FFI::Platypus::Buffer qw(scalar_to_buffer);
use FFI::Platypus::API qw(
	arguments_set_pointer
	arguments_set_uint32
	arguments_set_uint64
);


my @stack;

# See FFI::Platypus::Type::PointerSizeBuffer
*arguments_set_size_t
	= FFI::Platypus->new( api => 2 )->sizeof('size_t') == 4
	? \&arguments_set_uint32
	: \&arguments_set_uint64;

sub perl_to_native {
	my ($value, $i) = @_;
	die "Value must be a ScalarRef" unless ref $value eq 'SCALAR';

	my ($pointer, $size) = scalar_to_buffer($$value);

	push @stack, [ $value, $pointer, $size ];
	arguments_set_pointer( $i  , $pointer);
	arguments_set_size_t(  $i+1, $size);
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
