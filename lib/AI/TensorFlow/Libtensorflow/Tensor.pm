package AI::TensorFlow::Libtensorflow::Tensor;

use namespace::autoclean;
use AI::TensorFlow::Libtensorflow::Lib qw(arg);
use FFI::Platypus::Closure;
use FFI::Platypus::Buffer qw(buffer_to_scalar);
use List::Util qw(product);

my $ffi = AI::TensorFlow::Libtensorflow::Lib->ffi;
$ffi->mangler(AI::TensorFlow::Libtensorflow::Lib->mangler_default);

$ffi->load_custom_type('AI::TensorFlow::Libtensorflow::Lib::FFIType::TFPtrSizeScalarRef'
	=> 'tf_tensor_buffer'
);
$ffi->load_custom_type('AI::TensorFlow::Libtensorflow::Lib::FFIType::TFDimsBuffer'
	=> 'tf_dims_buffer'
);

# C: TF_NewTensor
#
# Constructor
=construct New

=for :signature
  #my $tensor = AI::TensorFlow::Libtensorflow::Tensor->New();
  #TODO

=for :param
= TFDataType $dtype
TODO
= Dims $dims
TODO
= ScalarRef[Bytes] $data
TODO
= CodeRef $deallocator
TODO
= Ref $deallocator_arg
TODO

=for :returns
= TFTensor
A new tensor with the given data and specification.

=tf_capi TF_NewTensor

=cut
$ffi->attach( [ 'NewTensor' => 'New' ] =>
	[
		arg 'TF_DataType' => 'dtype',

		# const int64_t* dims, int num_dims
		arg 'tf_dims_buffer'   => [ qw(dims num_dims) ],

		# void* data, size_t len
		arg 'tf_tensor_buffer' => [ qw(data len) ],

		arg 'opaque'      => 'deallocator',  # tensor_deallocator_t (deallocator)
		arg 'opaque'      => 'deallocator_arg',
	],
	=> 'TF_Tensor' => sub {
		my ($xs, $class,
			$dtype, $dims, $data,
			$deallocator, $deallocator_arg,
		) = @_;
		my $deallocator_closure = $ffi->closure( $deallocator );
		$deallocator_closure->sticky;
		my $deallocator_ptr = $ffi->cast(
			'tensor_deallocator_t', 'opaque',
			$deallocator_closure );

		my $obj = $xs->(
			$dtype,
			$dims,
			$data,
			$deallocator_ptr, $deallocator_arg,
		);

		$obj->{_deallocator_closure} = $deallocator_closure;

		$obj;
	});


# C: TF_AllocateTensor
#
# Constructor
=construct Allocate

TODO

=tf_capi TF_AllocateTensor

=cut
$ffi->attach( [ 'AllocateTensor', 'Allocate' ],
	[
		arg 'TF_DataType'     => 'dtype',
		arg 'tf_dims_buffer'  => [ qw(dims num_dims) ],
		arg 'size_t'          => 'len',
	],
	=> 'TF_Tensor' => sub {
		my ($xs, $class, @rest) = @_;
		my ($dtype, $dims, $len) = @rest;
		if( ! defined $len ) {
			$len = $dtype->Size * product(@$dims);
		}
		my $obj = $xs->(@rest);
	}
);

=method DESTROY

TODO

=tf_capi TF_DeleteTensor

=cut
$ffi->attach( [ 'DeleteTensor' => 'DESTROY' ],
	[ arg 'TF_Tensor' => 't' ]
	=> 'void'
	=> sub {
		my ($xs, $t) = @_;
		$xs->($t);
		if( exists $self->{_deallocator_closure} ) {
			$self->{_deallocator_closure}->unstick;
		}
	}
);

=attr Data

TODO

=tf_capi TF_TensorData

=cut
$ffi->attach( [ 'TensorData' => 'Data' ],
	[ 'TF_Tensor' ],
	=> 'opaque'
	=> sub {
		my ($xs, @rest) = @_;
		my ($self) = @rest;
		my $data_p = $xs->(@rest);
		my $buffer = buffer_to_scalar($data_p, $self->ByteSize);
	}
);

=attr ByteSize

=tf_capi TF_TensorByteSize

=cut
$ffi->attach( [ 'TensorByteSize' => 'ByteSize' ],
	[ 'TF_Tensor' ],
	=> 'size_t'
);

=attr Type

=tf_capi TF_TensorType

=cut
$ffi->attach( [ 'TensorType' => 'Type' ],
	[ arg 'TF_Tensor' => 't' ],
	=> 'TF_DataType',
);

=attr NumDims

TODO

=tf_capi TF_NumDims

=cut
$ffi->attach( [ 'NumDims' => 'NumDims' ],
	[ 'TF_Tensor' ],
	=> 'int',
);

=method Dim

TODO

=tf_capi TF_Dim

=cut
$ffi->attach( [ 'Dim' => 'Dim' ],
	[
		arg 'TF_Tensor' => 't',
		arg 'int'       => 'dim_index',
	],
	=> 'int',
);

1;
