package AI::TensorFlow::Libtensorflow::Graph;

use namespace::autoclean;
use AI::TensorFlow::Libtensorflow::Lib qw(arg);
my $ffi = AI::TensorFlow::Libtensorflow::Lib->ffi;
$ffi->mangler(AI::TensorFlow::Libtensorflow::Lib->mangler_default);

=construct New

=tf_capi TF_NewGraph

=cut
$ffi->attach( [ 'NewGraph' => 'New' ] => [] => 'TF_Graph' );

=destruct DESTROY

=tf_capi TF_DeleteGraph

=cut
$ffi->attach( [ 'DeleteGraph' => 'DESTROY' ] => [ arg 'TF_Graph' => 'self' ], 'void' );

=method ImportGraphDef

=tf_capi TF_GraphImportGraphDef

=cut
$ffi->attach( [ 'GraphImportGraphDef'  => 'ImportGraphDef'  ] => [
	arg 'TF_Graph' => 'graph',
	arg 'TF_Buffer' => 'graph_def',
	arg 'TF_ImportGraphDefOptions' => 'options',
	arg 'TF_Status' => 'status',
] => 'void' );

=method OperationByName

=tf_capi TF_GraphOperationByName

=cut
$ffi->attach( [ 'GraphOperationByName' => 'OperationByName' ] => [
	arg 'TF_Graph' => 'graph',
	arg 'string'   => 'oper_name',
] => 'TF_Operation' );

=method SetTensorShape

=tf_capi TF_GraphSetTensorShape

=cut
$ffi->attach( [ 'GraphSetTensorShape' => 'SetTensorShape' ] => [
	arg 'TF_Graph' => 'graph',
	arg 'TF_Output' => 'output',
	arg 'tf_dims_buffer' => [qw(dims num_dims)],
	arg 'TF_Status' => 'status',
] => 'void' );

=method GetTensorShape

=tf_capi TF_GraphGetTensorShape

=cut
$ffi->attach( ['GraphGetTensorShape' => 'GetTensorShape'] => [
	arg 'TF_Graph' => 'graph',
	arg 'TF_Output' => 'output',
	arg 'tf_dims_buffer' => [qw(dims num_dims)],
	arg 'TF_Status' => 'status',
] => 'void');

=method GetTensorNumDims

=tf_capi TF_GraphGetTensorNumDims

=cut
$ffi->attach( [ 'GraphGetTensorNumDims' => 'GetTensorNumDims' ] => [
	arg 'TF_Graph' => 'graph',
	arg 'TF_Output' => 'output',
	arg 'TF_Status' => 'status',
] => 'int');

1;
