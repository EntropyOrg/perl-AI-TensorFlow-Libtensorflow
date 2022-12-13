package AI::TensorFlow::Libtensorflow::Operation;
# ABSTRACT: An operation

use namespace::autoclean;
use AI::TensorFlow::Libtensorflow::Lib qw(arg);
use AI::TensorFlow::Libtensorflow::Output;
use AI::TensorFlow::Libtensorflow::Input;

my $ffi = AI::TensorFlow::Libtensorflow::Lib->ffi;
$ffi->mangler(AI::TensorFlow::Libtensorflow::Lib->mangler_default);

=attr Name

=tf_capi TF_OperationName

=cut
$ffi->attach( [ 'OperationName' => 'Name' ], [
	arg 'TF_Operation' => 'oper',
] => 'string');

=attr OpType

=tf_capi TF_OperationOpType

=cut
$ffi->attach( [ 'OperationOpType' => 'OpType' ], [
	arg 'TF_Operation' => 'oper',
] => 'string');

=attr Device

=tf_capi TF_OperationDevice

=cut
$ffi->attach( [ 'OperationDevice' => 'Device' ], [
	arg 'TF_Operation' => 'oper',
] => 'string');

=attr NumOutputs

=tf_capi TF_OperationNumOutputs

=cut
$ffi->attach( [ 'OperationNumOutputs' => 'NumOutputs' ], [
	arg 'TF_Operation' => 'oper',
] => 'int');

=attr OutputType

=tf_capi TF_OperationOutputType

=cut
$ffi->attach( [ 'OperationOutputType' => 'OutputType' ] => [
	arg 'TF_Output' => 'oper_out',
] => 'TF_DataType' => sub {
	my ($xs, $self, $output) = @_;
	# TODO coerce from LibtfPartialOutput here
	$xs->($output);
} );

=attr NumInputs

=tf_capi TF_OperationNumInputs

=cut
$ffi->attach( [ 'OperationNumInputs' => 'NumInputs' ] => [
	arg 'TF_Operation' => 'oper',
] => 'int' );

=attr InputType

=tf_capi TF_OperationInputType

=cut
$ffi->attach( [ 'OperationInputType'  => 'InputType' ] => [
	arg 'TF_Input' => 'oper_in',
] => 'TF_DataType' => sub {
	my ($xs, $self, $input) = @_;
	# TODO coerce from LibtfPartialInput here
	$xs->($input);
});

=attr NumControlInputs

=tf_capi TF_OperationNumControlInputs

=cut
$ffi->attach( [ 'OperationNumControlInputs' => 'NumControlInputs' ] => [
	arg 'TF_Operation' => 'oper',
] => 'int' );

=attr NumControlOutputs

=tf_capi TF_OperationNumControlOutputs

=cut
$ffi->attach( [ 'OperationNumControlOutputs' => 'NumControlOutputs' ] => [
	arg 'TF_Operation' => 'oper',
] => 'int' );

=method OutputListLength

=tf_capi TF_OperationOutputListLength

=cut
$ffi->attach( [ OperationOutputListLength => 'OutputListLength' ] => [
	arg 'TF_Operation' => 'oper',
	arg 'string' => 'arg_name',
	arg 'TF_Status' => 'status',
] => 'int');

=method InputListLength

=tf_capi TF_OperationInputListLength

=cut
$ffi->attach( [ 'OperationInputListLength' => 'InputListLength' ] => [
	arg 'TF_Operation' => 'oper',
	arg 'string' => 'arg_name',
	arg 'TF_Status' => 'status',
] => 'int' );

=method Input

=tf_capi TF_OperationInput

=cut
$ffi->attach( [ 'OperationInput' => 'Input' ] => [
	arg 'TF_Input' => 'oper_in',
] => 'TF_Output' => sub {
	my ($xs, $self, $input) = @_;
	# TODO coerce from LibtfPartialInput here
	$xs->($input);
});

=method AllInputs

=tf_capi TF_OperationAllInputs

=cut
$ffi->attach( [ 'OperationAllInputs' => 'AllInputs' ] => [
	arg 'TF_Operation' => 'oper',
	# TODO make OutputArray
	arg 'TF_Output_struct_array' => 'inputs',
	arg 'int' => 'max_inputs',
] => 'void' => sub {
	my ($xs, $oper) = @_;
	my $max_inputs = $oper->NumInputs;
	my $inputs = AI::TensorFlow::Libtensorflow::Output->_adef->create(0 + $max_inputs);
	$xs->($oper, $inputs, $max_inputs);
	return AI::TensorFlow::Libtensorflow::Output->_from_array($inputs);
});

=method OutputNumConsumers

=tf_capi TF_OperationOutputNumConsumers

=cut
$ffi->attach( [ 'OperationOutputNumConsumers' => 'OutputNumConsumers' ] => [
	arg 'TF_Output' => 'oper_out',
], 'int' => sub {
	my ($xs, $self, $output) = @_;
	# TODO coerce from LibtfPartialOutput here
	$xs->($output);
});

=method OutputConsumers

=tf_capi TF_OperationOutputConsumers

=cut
$ffi->attach( [ 'OperationOutputConsumers'  => 'OutputConsumers' ] => [
	# TODO simplify API
	arg 'TF_Output' => 'oper_out',
	arg 'TF_Input_struct_array' => 'consumers',
	arg 'int'                   => 'max_consumers',
] => 'int' => sub {
	my ($xs, $self, $output) = @_;
	my $max_consumers = $self->OutputNumConsumers( $output );
	my $consumers = AI::TensorFlow::Libtensorflow::Input->_adef->create( $max_consumers );
	my $count = $xs->($output, $consumers, $max_consumers);
	return AI::TensorFlow::Libtensorflow::Input->_from_array( $consumers );
});


use FFI::C::ArrayDef;
my $adef = FFI::C::ArrayDef->new(
	$ffi,
	name => 'TF_Operation_array',
	members => [
		FFI::C::StructDef->new(
			$ffi,
			members => [
				p => 'opaque'
			]
		)
	],
);
sub _adef {
	$adef;
}
sub _as_array {
	my $class = shift;
	my $array = $class->_adef->create(0 + @_);
	for my $idx (0..@_-1) {
		next unless defined $_[$idx];
		$array->[$idx]->p($ffi->cast('TF_Operation', 'opaque', $_[$idx]));
	}
	$array;
}

1;
