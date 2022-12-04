package AI::TensorFlow::Libtensorflow::SessionOptions;
# ABSTRACT: Holds options that can be passed during session creation

use namespace::autoclean;
use AI::TensorFlow::Libtensorflow::Lib qw(arg);;
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

=destruct DESTROY

=tf_capi TF_DeleteSessionOptions

=cut
$ffi->attach( [ 'DeleteSessionOptions' => 'DESTROY' ] => [
	arg 'TF_SessionOptions' => 'self',
] => 'void');

=method SetTarget

=tf_capi TF_SetTarget

=cut
$ffi->attach( 'SetTarget' => [
	arg 'TF_SessionOptions' => 'options',
	arg 'string' => 'target',
] => 'void');

=method SetConfig

=tf_capi TF_SetConfig

=cut
$ffi->attach( 'SetConfig' => [
	arg 'TF_SessionOptions' => 'options',
	arg 'tf_config_proto_buffer' => [qw(proto proto_len)],
	arg 'TF_Status' => 'status',
] => 'void' );

1;
