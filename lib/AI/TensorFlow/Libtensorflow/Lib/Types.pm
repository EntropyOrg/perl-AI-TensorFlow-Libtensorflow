package AI::TensorFlow::Libtensorflow::Lib::Types;
# ABSTRACT: Type library

use Type::Library 0.008 -base,
	-declare => [qw(
		TFTensor
		TFGraph
		TFDataType

		Dims
	)];
use Type::Utils -all;
use Types::Standard qw(ArrayRef Int);

=type TFTensor

Type for class L<AI::TensorFlow::Libtensorflow::Tensor>.

=cut
class_type TFTensor => { class => 'AI::TensorFlow::Libtensorflow::Tensor' };

=type TFGraph

Type for class L<AI::TensorFlow::Libtensorflow::Graph>.

=cut
class_type TFGraph => { class => 'AI::TensorFlow::Libtensorflow::Graph' };

=type TFDataType

Type for class L<AI::TensorFlow::Libtensorflow::DataType>

=cut
class_type TFDataType => { class => 'AI::TensorFlow::Libtensorflow::DataType' };

=type TFSession

Type for class L<AI::TensorFlow::Libtensorflow::Session>

=cut
class_type TFSession => { class => 'AI::TensorFlow::Libtensorflow::Session' };

=type TFSessionOptions

Type for class L<AI::TensorFlow::Libtensorflow::SessionOptions>

=cut
class_type TFSessionOptions => { class => 'AI::TensorFlow::Libtensorflow::SessionOptions' };

=type TFStatus

Type for class L<AI::TensorFlow::Libtensorflow::Status>

=cut
class_type TFStatus => { class => 'AI::TensorFlow::Libtensorflow::Status' };


=type Dims

C<ArrayRef> of C<Int>

=cut
declare Dims => as ArrayRef[Int];


1;
