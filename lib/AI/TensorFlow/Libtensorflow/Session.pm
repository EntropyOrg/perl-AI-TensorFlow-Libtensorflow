package AI::TensorFlow::Libtensorflow::Session;

use namespace::autoclean;
use AI::TensorFlow::Libtensorflow;
use AI::TensorFlow::Libtensorflow::Lib qw(arg);;
use AI::TensorFlow::Libtensorflow::Tensor;

my $ffi = AI::TensorFlow::Libtensorflow::Lib->ffi;
$ffi->mangler(AI::TensorFlow::Libtensorflow::Lib->mangler_default);

=construct New

TODO

=for :param
= TFGraph $graph
TODO
= TFSessionOptions $opt
TODO
= TFStatus $status

=for :returns
= TFSession
TODO

=tf_capi TF_NewSession

=cut
$ffi->attach( [ 'NewSession' => 'New' ] =>
	[
		arg 'TF_Graph' => 'graph',
		arg 'TF_SessionOptions' => 'opt',
		arg 'TF_Status' => 'status',
	],
	=> 'TF_Session' => sub {
		my ($xs, $class, @rest) = @_;
		return $xs->(@rest);
	});

=method Run

TODO

=tf_capi TF_SessionRun

=cut
$ffi->attach( [ 'SessionRun' => 'Run' ] =>
	[
		arg 'TF_Session' => 'session',

		# RunOptions
		#arg 'TF_Buffer*'  => 'run_options',
		arg 'opaque'  => 'run_options',

		# Input TFTensors
		arg 'TF_Output_array' => 'inputs',
		arg 'TF_Tensor_array' => 'input_values',
		arg 'int'             => 'ninputs',

		# Output TFTensors
		arg 'TF_Output_array' => 'outputs',
		arg 'TF_Tensor_array' => 'output_values',
		arg 'int'             => 'noutputs',

		# Target operations
		#arg 'TF_Operation_array' => 'target_opers',
		arg 'opaque'         => 'target_opers',
		arg 'int'            => 'ntargets',

		# RunMetadata
		#arg 'TF_Buffer*' => 'run_metadata',
		arg 'opaque'      => 'run_metadata',

		# Output status
		arg 'TF_Status' => 'status',
	],
	=> 'void'
);

=method Close

TODO

=tf_capi TF_CloseSession

=cut
$ffi->attach( [ 'CloseSession' => 'Close' ] =>
	[ 'TF_Session',
	'TF_Status',
	],
	=> 'void' );

1;
