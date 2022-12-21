package AI::TensorFlow::Libtensorflow::Eager::ContextOptions;
# ABSTRACT: Eager context options

use strict;
use warnings;
use AI::TensorFlow::Libtensorflow::Lib qw(arg);
my $ffi = AI::TensorFlow::Libtensorflow::Lib->ffi;
$ffi->mangler(AI::TensorFlow::Libtensorflow::Lib->mangler_default);

=construct New

=tf_capi TFE_NewContextOptions

=cut
$ffi->attach( [ 'NewContextOptions' => 'New' ] => [
] => 'TFE_ContextOptions' );

=destruct DESTROY

=tf_capi TFE_DeleteContextOptions

=cut
$ffi->attach( [ 'DeleteContextOptions' => 'DESTROY' ] => [
	arg TFE_ContextOptions => 'options'
] => 'void' );


1;
