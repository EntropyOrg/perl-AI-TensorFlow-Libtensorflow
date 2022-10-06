package AI::TensorFlow::Libtensorflow::Lib::Types;
# ABSTRACT: Type library

use Type::Library 0.008 -base,
	-declare => [qw(
		TFTensor
		TFGraph
	)];
use Type::Utils -all;

=type TFTensor

Type for class L<AI::TensorFlow::Libtensorflow::Tensor>.

=cut
class_type TFTensor => { class => 'AI::TensorFlow::Libtensorflow::Tensor' };

=type TFGraph

Type for class L<AI::TensorFlow::Libtensorflow::Graph>.

=cut
class_type TFGraph => { class => 'AI::TensorFlow::Libtensorflow::Graph' };

1;
