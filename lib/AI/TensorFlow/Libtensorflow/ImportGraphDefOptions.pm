package AI::TensorFlow::Libtensorflow::ImportGraphDefOptions;

use namespace::autoclean;
use AI::TensorFlow::Libtensorflow::Lib qw(arg);

my $ffi = AI::TensorFlow::Libtensorflow::Lib->ffi;
$ffi->mangler(AI::TensorFlow::Libtensorflow::Lib->mangler_default);

=construct New

=tf_capi TF_NewImportGraphDefOptions

=cut
$ffi->attach( [ 'NewImportGraphDefOptions' => 'New' ] => [] => 'TF_ImportGraphDefOptions' );

=destruct DESTROY

=tf_capi TF_DeleteImportGraphDefOptions

=cut
$ffi->attach( [ 'DeleteImportGraphDefOptions' => 'DESTROY' ] => [
	arg 'TF_ImportGraphDefOptions' => 'self',
] => 'void' );

1;
