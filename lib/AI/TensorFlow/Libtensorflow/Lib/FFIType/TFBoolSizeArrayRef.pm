package AI::TensorFlow::Libtensorflow::Lib::FFIType::TFBoolSizeArrayRef;
# ABSTRACT: Type to hold boolean list as unsigned char** , int

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
