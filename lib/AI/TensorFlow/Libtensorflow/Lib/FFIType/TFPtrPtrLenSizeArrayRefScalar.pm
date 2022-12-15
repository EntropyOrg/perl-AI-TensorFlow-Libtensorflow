package AI::TensorFlow::Libtensorflow::Lib::FFIType::TFPtrPtrLenSizeArrayRefScalar;
# ABSTRACT: Type to hold string list as void** strings, size_t* lengths, int num_items

use strict;
use warnings;
# TODO implement this

sub perl_to_native {
	...
}

sub perl_to_native_post {
	...
}

sub ffi_custom_type_api_1 {
	{
		'native_type' => 'opaque',
		'perl_to_native' => \&perl_to_native,
		'perl_to_native_post' => \&perl_to_native_post,
		argument_count => 3,
	}
}

1;
