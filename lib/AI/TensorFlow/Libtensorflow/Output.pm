package AI::TensorFlow::Libtensorflow::Output;

use FFI::C;

use AI::TensorFlow::Libtensorflow::Lib;
my $ffi = AI::TensorFlow::Libtensorflow::Lib->ffi;
$ffi->mangler(AI::TensorFlow::Libtensorflow::Lib->mangler_default);
FFI::C->ffi($ffi);

FFI::C->struct( 'TF_Output' => [
	oper  => 'TF_Operation',
	index => 'int',
]);

1;
