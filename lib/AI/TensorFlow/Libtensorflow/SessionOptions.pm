package AI::TensorFlow::Libtensorflow::SessionOptions;

use namespace::autoclean;
use AI::TensorFlow::Libtensorflow;
my $ffi = AI::TensorFlow::Libtensorflow::Lib->ffi;
$ffi->mangler(AI::TensorFlow::Libtensorflow::Lib->mangler_default);

=construct New

=for :returns
= TFSessionOptions
A new options object.

=tf_capi TF_NewSessionOptions

=cut
$ffi->attach( [ 'NewSessionOptions' => 'New' ] =>
	[ ], => 'TF_SessionOptions' );

1;
