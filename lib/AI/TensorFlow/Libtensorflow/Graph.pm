package AI::TensorFlow::Libtensorflow::Graph;
# ABSTRACT: A TensorFlow computation, represented as a dataflow graph

use namespace::autoclean;
use AI::TensorFlow::Libtensorflow::Lib qw(arg);
use AI::TensorFlow::Libtensorflow::Buffer;
use AI::TensorFlow::Libtensorflow::Output;
my $ffi = AI::TensorFlow::Libtensorflow::Lib->ffi;
$ffi->mangler(AI::TensorFlow::Libtensorflow::Lib->mangler_default);

=construct New

=for :signature
New()

  my $graph = Graph->New;
  ok $graph, 'created graph';

=for :returns
= TFGraph
An empty graph.

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
] => 'void');

=method GetTensorShape

=tf_capi TF_GraphGetTensorShape

=cut
$ffi->attach( ['GraphGetTensorShape' => 'GetTensorShape'] => [
	arg 'TF_Graph' => 'graph',
	arg 'TF_Output' => 'output',
	arg 'tf_dims_buffer' => [qw(dims num_dims)],
	arg 'TF_Status' => 'status',
] => 'void' => sub {
	my ($xs, @rest) = @_;
	my ($graph, $output, $status) = @rest;
	my $dims = [ (0)x($graph->GetTensorNumDims($output, $status)) ];
	$xs->($graph, $output, $dims, $status);
	return $dims;
});

=method GetTensorNumDims

=tf_capi TF_GraphGetTensorNumDims

=cut
$ffi->attach( [ 'GraphGetTensorNumDims' => 'GetTensorNumDims' ] => [
	arg 'TF_Graph' => 'graph',
	arg 'TF_Output' => 'output',
	arg 'TF_Status' => 'status',
] => 'int');

=method NextOperation

=tf_capi TF_GraphNextOperation

=cut
$ffi->attach( [ 'GraphNextOperation' => 'NextOperation' ] => [
	arg 'TF_Graph' => 'graph',
	arg 'size_t*'  => 'pos',
] => 'TF_Operation');

1;
__END__

=head1 SYNOPSIS

  use aliased 'AI::TensorFlow::Libtensorflow::Graph' => 'Graph';

=head1 DESCRIPTION



=cut
