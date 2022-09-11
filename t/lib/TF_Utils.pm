package TF_Utils;

use AI::TensorFlow::Libtensorflow;
use Path::Tiny;

sub ScalarStringTensor {
	my ($str, $status) = @_;
	#my $tensor = AI::TensorFlow::Libtensorflow::Tensor->_Allocate(
		#AI::TensorFlow::Libtensorflow::DType::STRING,
		#\@dims, $ndims,
		#$data_size_bytes,
	#);
	...
}

sub ReadBufferFromFile {
	my ($path) = @_;
	my $data = path($path)->slurp_raw;
	my $buffer = AI::TensorFlow::Libtensorflow::Buffer->NewFromData(
		$data
	);
}

sub LoadGraph {
	my ($path, $checkpoint_prefix, $status) = @_;
	my $buffer = ReadBufferFromFile( $path );

	$status //= AI::TensorFlow::Libtensorflow::Status->_New;

	my $graph = AI::TensorFlow::Libtensorflow::Graph->_New;
	my $opts  = AI::TensorFlow::Libtensorflow::ImportGraphDefOptions->_New;

	$graph->ImportGraphDef( $buffer, $opts, $status );

	$opts->_Delete;
	$buffer->_Delete;

	if( $status->GetCode ne 'OK' ) {
		$graph->_Delete;
		return undef;
	}

	if( ! defined $checkpoint_prefix ) {
		return $graph;
	}
}

1;
