package AI::TensorFlow::Libtensorflow::DataType;
# ABSTRACT: Datatype enum

use namespace::autoclean;
use AI::TensorFlow::Libtensorflow::Lib;

my $ffi = AI::TensorFlow::Libtensorflow::Lib->ffi;
$ffi->mangler(AI::TensorFlow::Libtensorflow::Lib->mangler_for_object('DataType'));

# enum TF_DataType
# From <tensorflow/c/tf_datatype.h>
$ffi->load_custom_type('::Enum', 'TF_DataType',
	{ rev => 'int', package => __PACKAGE__ },
	# from tensorflow/c/tf_datatype.h
	[ FLOAT      => 1 ],
	[ DOUBLE     => 2 ],
	[ INT32      => 3 ], #// Int32 tensors are always in 'host' memory.
	[ UINT8      => 4 ],
	[ INT16      => 5 ],
	[ INT8       => 6 ],
	[ STRING     => 7 ],
	[ COMPLEX64  => 8 ],  # // Single-precision complex
	[ COMPLEX    => 8 ], # // Old identifier kept for API backwards compatibility
	[ INT64      => 9 ],
	[ BOOL       => 10 ],
	[ QINT8      => 11 ],#    // Quantized int8
	[ QUINT8     => 12 ],#   // Quantized uint8
	[ QINT32     => 13 ],#   // Quantized int32
	[ BFLOAT16   => 14 ],# // Float32 truncated to 16 bits.  Only for cast ops.
	[ QINT16     => 15 ],#   // Quantized int16
	[ QUINT16    => 16 ],#  // Quantized uint16
	[ UINT16     => 17 ],
	[ COMPLEX128 => 18 ],# // Double-precision complex
	[ HALF       => 19 ],
	[ RESOURCE   => 20 ],
	[ VARIANT    => 21 ],
	[ UINT32     => 22 ],
	[ UINT64     => 23 ],
);

=method Size

  my $size = $dtype->Size();

=for :returns
= size_t

=tf_capi TF_DataTypeSize

=cut
$ffi->attach( 'Size' => ['TF_DataType'] => 'size_t' );

1;
