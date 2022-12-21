package AI::TensorFlow::Libtensorflow::Eager::Context;
# ABSTRACT: Eager context

use strict;
use warnings;
use AI::TensorFlow::Libtensorflow::Lib qw(arg);
my $ffi = AI::TensorFlow::Libtensorflow::Lib->ffi;
$ffi->mangler(AI::TensorFlow::Libtensorflow::Lib->mangler_default);

=construct New

=tf_capi TFE_NewContext

=cut
$ffi->attach( [ 'NewContext' => 'New' ] => [
	arg TFE_ContextOptions => 'opts',
	arg TF_Status => 'status'
] => 'TFE_Context' => sub {
	my ($xs, $class, @rest) = @_;
	$xs->(@rest);
} );

=tf_capi TFE_DeleteContext


1;
