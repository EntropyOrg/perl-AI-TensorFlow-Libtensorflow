package AI::TensorFlow::Libtensorflow::Tensor;

use AI::TensorFlow::Libtensorflow::Lib;
my $ffi = AI::TensorFlow::Libtensorflow::Lib->ffi;
$ffi->mangler(AI::TensorFlow::Libtensorflow::Lib->mangler_default);

# C: TF_NewTensor
#
# Constructor
=construct New

TODO

=tf_capi TF_NewTensor

=cut
$ffi->attach( [ 'NewTensor' => '_New' ] =>
	[ 'TF_DataType', # dtype

		'int64_t[]',   # (dims)
		'int',         # (num_dims)

		'opaque',      # (data)
		'size_t',      # (len)

		'opaque',      # tensor_deallocator_t (deallocator)
		'opaque',      # (deallocator_arg)
	],
	=> 'TF_Tensor' => sub {
		my ($xs, $class,
			$dtype,
			$dims, $num_dims,
			$data, $len,
			$deallocator, $deallocator_arg,
		) = @_;
		my $deallocator_ptr = $ffi->cast( 'tensor_deallocator_t', 'opaque', $deallocator);
		my $obj = $xs->(
			$dtype,
			$dims, $num_dims,
			$data, $len,
			$deallocator_ptr, $deallocator_arg,
		);

		$obj->{PDL} = $$deallocator_arg;

		$obj;
	});


# C: TF_AllocateTensor
#
# Constructor
=construct Allocate

TODO

=tf_capi TF_AllocateTensor

=cut
$ffi->attach( [ 'AllocateTensor', '_Allocate' ],
	[ 'TF_DataType', # dtype'
		'int64_t[]',   # (dims)
		'int',         # (num_dims)
		'size_t',      # (len)
	],
	=> 'TF_Tensor' => sub {
		my ($xs, $class, @rest) = @_;
		my $obj = $xs->(@rest);
	}
);

=attr Data

=tf_capi TF_TensorData

=cut
$ffi->attach( [ 'TensorData' => 'Data' ],
	[ 'TF_Tensor' ],
	=> 'opaque'
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
	[ 'TF_Tensor' ],
	=> 'TF_DataType',
);

=attr NumDims

=tf_capi TF_NumDims

=cut
$ffi->attach( [ 'NumDims' => 'NumDims' ],
	[ 'TF_Tensor' ],
	=> 'int',
);

1;
