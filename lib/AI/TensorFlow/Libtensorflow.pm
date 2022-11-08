package AI::TensorFlow::Libtensorflow;
# ABSTRACT: Bindings for Libtensorflow deep learning library

use strict;
use warnings;

use AI::TensorFlow::Libtensorflow::Lib;

use AI::TensorFlow::Libtensorflow::DataType;
use AI::TensorFlow::Libtensorflow::Status;


use AI::TensorFlow::Libtensorflow::Buffer;
use AI::TensorFlow::Libtensorflow::Tensor;

use AI::TensorFlow::Libtensorflow::Operation;

use AI::TensorFlow::Libtensorflow::ImportGraphDefOptions;
use AI::TensorFlow::Libtensorflow::Graph;

use AI::TensorFlow::Libtensorflow::Output;

use AI::TensorFlow::Libtensorflow::SessionOptions;
use AI::TensorFlow::Libtensorflow::Session;

use FFI::C;

my $ffi = AI::TensorFlow::Libtensorflow::Lib->ffi;
FFI::C->ffi($ffi);

$ffi->mangler(AI::TensorFlow::Libtensorflow::Lib->mangler_default);

sub new {
	my ($class) = @_;
	bless {}, $class;
}

=classmethod Version

  my $version = $class->Version();

=for :returns
= Str
Version number for the C<libtensorflow> library.

=tf_capi TF_Version

=cut
$ffi->attach( 'Version' => [], 'string' );#}}}

1;

=head1 DESCRIPTION

The C<libtensorflow> library provides low-level C bindings
for TensorFlow with a stable ABI.

=cut
