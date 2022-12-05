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
use AI::TensorFlow::Libtensorflow::Output;

use AI::TensorFlow::Libtensorflow::ImportGraphDefOptions;
use AI::TensorFlow::Libtensorflow::Graph;

use AI::TensorFlow::Libtensorflow::OperationDescription;

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

  my $version = Libtensorflow->Version();
  like $version, qr/(\d|\.)+/, 'Got version';

=for :returns
= Str
Version number for the C<libtensorflow> library.

=tf_capi TF_Version

=cut
$ffi->attach( 'Version' => [], 'string' );#}}}

=classmethod GetAllOpList

=for :signature
GetAllOpList()

  my $buf = Libtensorflow->GetAllOpList();
  cmp_ok $buf->length, '>', 0, 'Non-empty buffer';

=for :returns
= TFBuffer
Contains a serialized OpList proto for ops registered in this address space.

=tf_capi TF_GetAllOpList

=cut
$ffi->attach( 'GetAllOpList' => [], 'TF_Buffer' );

1;

=head1 SYNOPSIS

  use aliased 'AI::TensorFlow::Libtensorflow' => 'Libtensorflow';

=head1 DESCRIPTION

The C<libtensorflow> library provides low-level C bindings
for TensorFlow with a stable ABI.

=cut
