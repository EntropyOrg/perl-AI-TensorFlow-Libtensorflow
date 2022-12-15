package AI::TensorFlow::Libtensorflow::_Misc;
# ABSTRACT: Private API

use strict;
use warnings;
use namespace::autoclean;
use AI::TensorFlow::Libtensorflow::Lib qw(arg);

my $ffi = AI::TensorFlow::Libtensorflow::Lib->ffi;
$ffi->mangler(AI::TensorFlow::Libtensorflow::Lib->mangler_default);

=func FromProto

=tf_capi TF_TensorFromProto

=cut
$ffi->attach( 'TensorFromProto' => [
	arg 'TF_Buffer' => 'from',
	arg 'TF_Tensor' => 'to',
	arg 'TF_Status' => 'status',
]);


1;
