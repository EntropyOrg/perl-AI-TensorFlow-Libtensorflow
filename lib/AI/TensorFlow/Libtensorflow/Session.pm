package AI::TensorFlow::Libtensorflow::Session;
# ABSTRACT: Session for driving ::Graph execution

use namespace::autoclean;
use AI::TensorFlow::Libtensorflow;
use AI::TensorFlow::Libtensorflow::Lib qw(arg);;

use AI::TensorFlow::Libtensorflow::Tensor;
use AI::TensorFlow::Libtensorflow::Output;

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

=for :param
= Maybe[TFBuffer] $run_options
TODO
= ArrayRef[TFOutput] $inputs
TODO
= ArrayRef[TFTensor] $input_values
TODO
= ArrayRef[TFOutput] $outputs
TODO
= ArrayRef[TFTensor] $output
TODO
= ArrayRef[TFOperation] $target_opers
TODO
= Maybe[TFBuffer] $run_metadata
TODO
= TFStatus $status
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
		arg 'TF_Output_struct_array' => 'inputs',
		arg 'TF_Tensor_array' => 'input_values',
		arg 'int'             => 'ninputs',

		# Output TFTensors
		arg 'TF_Output_struct_array' => 'outputs',
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
	=> 'void' => sub {
		my ($xs,
			$self,
			$run_options,
			$inputs , $input_values,
			$outputs, $output_values,
			$target_opers,
			$run_metadata,
			$status ) = @_;

		die "Mismatch in number of inputs and input values" unless $#$inputs == $#$input_values;
		my $input_v_a  = AI::TensorFlow::Libtensorflow::Tensor->_as_array(@$input_values);
		my $output_v_a = AI::TensorFlow::Libtensorflow::Tensor->_adef->create( 0+@$outputs );


		my @target_opers_args = defined $target_opers
			? do {
				my $target_opers_a = AI::TensorFlow::Libtensorflow::Operation->_as_array( @$target_opers );
				( $target_opers_a, $target_opers_a->count )
			}
			: ( undef, 0 );

		$inputs  = AI::TensorFlow::Libtensorflow::Output->_as_array( @$inputs );
		$outputs = AI::TensorFlow::Libtensorflow::Output->_as_array( @$outputs );
		$xs->($self,
			$run_options,

			# Inputs
			$inputs, $input_v_a , $input_v_a->count,

			# Outputs
			$outputs, $output_v_a, $output_v_a->count,

			@target_opers_args,

			$run_metadata,

			$status
		);

		@{$output_values} =
			map {
				$ffi->cast(
					'opaque',
					'TF_Tensor',
					$output_v_a->[$_]->p)
			} 0.. $output_v_a->count - 1
	}
);

=method ListDevices

=tf_capi TF_SessionListDevices

=cut
$ffi->attach( [ 'SessionListDevices' => 'ListDevices' ] => [
	arg TF_Session => 'session',
	arg TF_Status => 'status',
] => 'TF_DeviceList');

=method Close

TODO

=tf_capi TF_CloseSession

=cut
$ffi->attach( [ 'CloseSession' => 'Close' ] =>
	[ 'TF_Session',
	'TF_Status',
	],
	=> 'void' );

sub DESTROY {
	my ($self) = @_;
	my $s = AI::TensorFlow::Libtensorflow::Status->New;
	$self->Close($s);
	# TODO this may not be needed with automatic Status handling
	die "Could not close session" unless $s->GetCode eq 'OK';
}

1;
