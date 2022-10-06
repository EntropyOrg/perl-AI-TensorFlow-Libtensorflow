package AI::TensorFlow::Libtensorflow::SessionOptions;

use namespace::autoclean;
use AI::TensorFlow::Libtensorflow;
my $ffi = AI::TensorFlow::Libtensorflow::Lib->ffi;
$ffi->mangler(AI::TensorFlow::Libtensorflow::Lib->mangler_default);

$ffi->attach( [ 'NewSessionOptions' => '_New' ] =>
	[ ], => 'TF_SessionOptions' );

1;
