package AI::TensorFlow::Libtensorflow::ImportGraphDefOptions;
# ABSTRACT: Holds options that can be passed to ::Graph::ImportGraphDef

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

=method SetPrefix

=tf_capi TF_ImportGraphDefOptionsSetPrefix

=cut
$ffi->attach( [ 'ImportGraphDefOptionsSetPrefix' => 'SetPrefix' ] => [
	arg 'TF_ImportGraphDefOptions' => 'opts',
	arg 'string' => 'prefix',
] => 'void' );

=method AddInputMapping

=tf_capi TF_ImportGraphDefOptionsAddInputMapping

=cut
$ffi->attach( [ 'ImportGraphDefOptionsAddInputMapping' => 'AddInputMapping' ] => [
	arg 'TF_ImportGraphDefOptions' => 'opts',
	arg 'string' => 'src_name',
	arg 'int' => 'src_index',
	arg 'TF_Output' => 'dst',
] => 'void');

=method AddReturnOutput

=tf_capi TF_ImportGraphDefOptionsAddReturnOutput

=cut
$ffi->attach( [ 'ImportGraphDefOptionsAddReturnOutput' => 'AddReturnOutput' ] => [
	arg TF_ImportGraphDefOptions => 'opts',
	arg string => 'oper_name',
	arg int => 'index',
] => 'void' );

=method NumReturnOutputs

=tf_capi TF_ImportGraphDefOptionsNumReturnOutputs

=cut
$ffi->attach( [ 'ImportGraphDefOptionsNumReturnOutputs' => 'NumReturnOutputs' ] => [
	arg TF_ImportGraphDefOptions => 'opts',
] => 'int');

=method AddReturnOperation

=tf_capi TF_ImportGraphDefOptionsAddReturnOperation

=cut
$ffi->attach( [ 'ImportGraphDefOptionsAddReturnOperation' => 'AddReturnOperation' ] => [
	arg TF_ImportGraphDefOptions => 'opts',
	arg string => 'oper_name',
] => 'void' );

=method NumReturnOperations

=tf_capi TF_ImportGraphDefOptionsNumReturnOperations

=cut
$ffi->attach( [ 'ImportGraphDefOptionsNumReturnOperations' => 'NumReturnOperations' ] => [
	arg TF_ImportGraphDefOptions => 'opts',
] => 'int' );

=method AddControlDependency

=tf_capi TF_ImportGraphDefOptionsAddControlDependency

=cut
$ffi->attach( [ 'ImportGraphDefOptionsAddControlDependency' => 'AddControlDependency' ] => [
	arg TF_ImportGraphDefOptions => 'opts',
	arg TF_Operation => 'oper',
] => 'void' );

=method RemapControlDependency

=tf_capi TF_ImportGraphDefOptionsRemapControlDependency

=cut
$ffi->attach( [ 'ImportGraphDefOptionsRemapControlDependency' => 'RemapControlDependency' ] => [
	arg TF_ImportGraphDefOptions => 'opts',
	arg string => 'src_name',
	arg TF_Operation => 'dst',
] => 'void' );

1;
