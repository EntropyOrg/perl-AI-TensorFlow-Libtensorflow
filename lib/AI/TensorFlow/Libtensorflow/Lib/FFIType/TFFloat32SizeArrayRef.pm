package AI::TensorFlow::Libtensorflow::Lib::FFIType::TFFloat32SizeArrayRef;
# ABSTRACT: Type to hold float list as float* + int

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
		argument_count => 2,
	}
}

1;
