package AI::TensorFlow::Libtensorflow;
# ABSTRACT: Bindings for TensorFlow deep learning library

use strict;
use warnings;

use AI::TensorFlow::Libtensorflow::Lib;
use AI::TensorFlow::Libtensorflow::Output;
use AI::TensorFlow::Libtensorflow::DataType;
use AI::TensorFlow::Libtensorflow::Status;

use AI::TensorFlow::Libtensorflow::Buffer;
use AI::TensorFlow::Libtensorflow::Tensor;
use AI::TensorFlow::Libtensorflow::ImportGraphDefOptions;
use AI::TensorFlow::Libtensorflow::Graph;
use AI::TensorFlow::Libtensorflow::SessionOptions;
use AI::TensorFlow::Libtensorflow::Session;
use FFI::C;

my $ffi = AI::TensorFlow::Libtensorflow::Lib->ffi;
FFI::C->ffi($ffi);

$ffi->mangler(AI::TensorFlow::Libtensorflow::Lib->mangler_default);


# ::TensorFlow {{{
sub new {
	my ($class) = @_;
	bless {}, $class;
}

$ffi->attach( [ Version => 'version' ] => [], 'string' );#}}}


package AI::TensorFlow::Libtensorflow::Output_Array {#{{{
	FFI::C->array('TF_Output_array', [ 'TF_Output' ]);
}
#}}}



__END__

1;
# vim:fdm=marker
