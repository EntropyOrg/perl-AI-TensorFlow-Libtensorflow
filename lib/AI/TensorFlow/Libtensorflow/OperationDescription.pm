package AI::TensorFlow::Libtensorflow::OperationDescription;
# ABSTRACT: Operation being built

use namespace::autoclean;
use AI::TensorFlow::Libtensorflow::Lib qw(arg);
use AI::TensorFlow::Libtensorflow::Lib::FFIType::Variant::PackableArrayRef;

my $ffi = AI::TensorFlow::Libtensorflow::Lib->ffi;
$ffi->mangler(AI::TensorFlow::Libtensorflow::Lib->mangler_default);
$ffi->load_custom_type('AI::TensorFlow::Libtensorflow::Lib::FFIType::TFPtrSizeScalarRef'
        => 'tf_attr_string_buffer'
);
$ffi->load_custom_type('AI::TensorFlow::Libtensorflow::Lib::FFIType::TFPtrPtrLenSizeArrayRefScalar'
        => 'tf_attr_string_list'
);
$ffi->load_custom_type(PackableArrayRef('Int64ArrayRef', pack_type => 'q')
        => 'tf_attr_int_list'
);
$ffi->load_custom_type(PackableArrayRef('Float32ArrayRef', pack_type => 'f')
	=> 'tf_attr_float_list'
);
$ffi->load_custom_type(PackableArrayRef('BoolArrayRef', pack_type => 'C')
	=> 'tf_attr_bool_list',
);

=construct New

=tf_capi TF_NewOperation

=cut
$ffi->attach( [ 'NewOperation' => 'New' ] => [
	arg 'TF_Graph' => 'graph',
	arg 'string'   => 'op_type',
	arg 'string'   => 'oper_name',
] => 'TF_OperationDescription' => sub {
	my ($xs, $class, @rest) = @_;
	$xs->(@rest);
});

=construct NewLocked

=tf_capi TF_NewOperationLocked

=cut
$ffi->attach( [ 'NewOperationLocked' => 'NewLocked' ] => [
	arg 'TF_Graph' => 'graph',
	arg 'string'   => 'op_type',
	arg 'string'   => 'oper_name',
] => 'TF_OperationDescription' );

=method SetDevice

=tf_capi TF_SetDevice

=cut
$ffi->attach( 'SetDevice' => [
	arg 'TF_OperationDescription' => 'desc',
	arg 'string' => 'device',
] => 'void');

=method AddInput

=tf_capi TF_AddInput

=cut
$ffi->attach( 'AddInput' => [
	arg 'TF_OperationDescription' => 'desc',
	arg 'TF_Output' => 'input',
] => 'void');

=method AddInputList

=tf_capi TF_AddInputList

=cut
$ffi->attach( AddInputList => [
	arg 'TF_OperationDescription' => 'desc',
	arg 'TF_Output_struct_array' => 'inputs',
	arg 'int' => 'num_inputs',
] => 'void' => sub {
	my $xs = shift;
	$_[1]  = AI::TensorFlow::Libtensorflow::Output->_as_array( @{ $_[1] } );
	$_[2]  = $_[1]->count;
	$xs->(@_);
});

=method AddControlInput

=tf_capi TF_AddControlInput

=cut
$ffi->attach( AddControlInput => [
	arg 'TF_OperationDescription' => 'desc',
	arg 'TF_Operation' => 'input',
] => 'void');

=method ColocateWith

=tf_capi TF_ColocateWith

=cut
$ffi->attach( ColocateWith => [
	arg 'TF_OperationDescription' => 'desc',
	arg 'TF_Operation' => 'op',
] => 'void');

=method SetAttrString

=tf_capi TF_SetAttrString

=cut
$ffi->attach( SetAttrString => [
	arg 'TF_OperationDescription' => 'desc',
	arg 'string' => 'attr_name',
	arg tf_attr_string_buffer => [qw(value length)],
] => 'void');

=method SetAttrStringList

=tf_capi TF_SetAttrStringList

=cut
$ffi->attach(SetAttrStringList => [
	arg 'TF_OperationDescription' => 'desc',
	arg 'string' => 'attr_name',
	arg 'tf_attr_string_list' => [qw(values lengths num_values)],
] => 'void');

=method SetAttrInt

=tf_capi TF_SetAttrInt

=cut
$ffi->attach( SetAttrInt => [
	arg 'TF_OperationDescription' => 'desc',
	arg 'string' => 'attr_name',
	arg int64_t  => 'value',
] => 'void');

=method SetAttrIntList

=tf_capi TF_SetAttrIntList

=cut
$ffi->attach( SetAttrIntList => [
	arg 'TF_OperationDescription' => 'desc',
	arg 'string' => 'attr_name',
	arg 'tf_attr_int_list' => [qw(values num_values)],
] => 'void');

=method SetAttrFloat

=tf_capi TF_SetAttrFloat

=cut
$ffi->attach( SetAttrFloat => [
	arg 'TF_OperationDescription' => 'desc',
	arg 'string' => 'attr_name',
	arg 'float' => 'value',
] => 'void');

=method SetAttrFloatList

=tf_capi TF_SetAttrFloatList

=cut
$ffi->attach(SetAttrFloatList => [
	arg 'TF_OperationDescription' => 'desc',
	arg 'string' => 'attr_name',
	arg 'tf_attr_float_list' => [qw(values num_values)],
] => 'void');

=method SetAttrBool

=tf_capi TF_SetAttrBool

=cut
$ffi->attach( SetAttrBool => [
	arg 'TF_OperationDescription' => 'desc',
	arg 'string' => 'attr_name',
	arg 'unsigned char' => 'value',
] => 'void');

=method SetAttrBoolList

=tf_capi TF_SetAttrBoolList

=cut
$ffi->attach( SetAttrBoolList => [
	arg 'TF_OperationDescription' => 'desc',
	arg 'string' => 'attr_name',
	arg 'tf_attr_bool_list' => [qw(values num_values)],
] => 'void');

=method SetAttrType

=tf_capi TF_SetAttrType

=cut
$ffi->attach(SetAttrType => [
	arg 'TF_OperationDescription' => 'desc',
	arg 'string' => 'attr_name',
	arg 'TF_DataType' => 'value',
] => 'void');

=method SetAttrTypeList

=tf_capi TF_SetAttrTypeList

=cut
$ffi->attach( SetAttrTypeList => [
	arg 'TF_OperationDescription' => 'desc',
	arg 'string' => 'attr_name',

	# TODO
	arg 'opaque' => 'values',
	#arg 'TF_DataType*' => 'values',
	arg 'int' => 'num_values',
]);

=method SetAttrPlaceholder

=tf_capi TF_SetAttrPlaceholder

=cut
$ffi->attach( SetAttrPlaceholder => [
	arg 'TF_OperationDescription' => 'desc',
	arg 'string' => 'attr_name',
	arg 'string' => 'placeholder',
] => 'void');

=method SetAttrFuncName

=tf_capi TF_SetAttrFuncName

=cut
$ffi->attach( SetAttrFuncName => [
	arg 'TF_OperationDescription' => 'desc',
	arg 'string' => 'attr_name',
	arg 'tf_attr_string_buffer' => [qw(value length)],
] => 'void');

=method SetAttrShape

=tf_capi TF_SetAttrShape

=cut
$ffi->attach( SetAttrShape => [
	arg 'TF_OperationDescription' => 'desc',
	arg 'string' => 'attr_name',
	arg 'tf_dims_buffer' => [qw(dims num_dims)],
] => 'void');

=method SetAttrShapeList

=tf_capi TF_SetAttrShapeList

=cut
$ffi->attach( SetAttrShapeList => [
	arg 'TF_OperationDescription' => 'desc',
	arg 'string' => 'attr_name',
	# TODO
	arg 'opaque' => 'const int64_t* const* dims',
	arg 'opaque' => 'const int* num_dims',
	arg 'int'    => 'num_shapes',
]);

=method SetAttrTensorShapeProto

=tf_capi TF_SetAttrTensorShapeProto

=cut
$ffi->attach(SetAttrTensorShapeProto => [
	arg 'TF_OperationDescription' => 'desc',
	arg 'string' => 'attr_name',
	arg 'tf_tensor_shape_proto_buffer' => [qw(proto proto_len)],
	arg 'TF_Status' => 'status',
] => 'void');

=method SetAttrTensorShapeProtoList

=tf_capi TF_SetAttrTensorShapeProtoList

=cut
$ffi->attach( SetAttrTensorShapeProtoList => [
	# TODO
] => 'void');

=method SetAttrTensor

=tf_capi TF_SetAttrTensor

=cut
$ffi->attach( SetAttrTensor => [
	arg 'TF_OperationDescription' => 'desc',
	arg 'string' => 'attr_name',
	arg 'TF_Tensor' => 'value',
	arg 'TF_Status' => 'status',
] => 'void');

=method SetAttrTensorList

=tf_capi TF_SetAttrTensorList

=cut
$ffi->attach( SetAttrTensorList => [
	# TODO
] => 'void');

=method SetAttrValueProto

=tf_capi TF_SetAttrValueProto

=cut
$ffi->attach(SetAttrValueProto => [
	arg 'TF_OperationDescription' => 'desc',
	arg 'string' => 'attr_name',
	arg 'tf_attr_value_proto_buffer' => [qw(proto proto_len)],
	arg 'TF_Status' => 'status',
] => 'void');

=method FinishOperation

=tf_capi TF_FinishOperation

=cut
$ffi->attach(FinishOperation => [
	arg 'TF_OperationDescription' => 'desc',
	arg 'TF_Status' => 'status',
] => 'TF_Operation');

=method FinishOperationLocked

=tf_capi TF_FinishOperationLocked

=cut
$ffi->attach(FinishOperationLocked => [
	arg 'TF_OperationDescription' => 'desc',
	arg 'TF_Status' => 'status',
] => 'TF_Operation');

1;
