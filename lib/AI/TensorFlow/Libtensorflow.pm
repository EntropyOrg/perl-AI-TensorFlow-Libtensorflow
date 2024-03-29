package AI::TensorFlow::Libtensorflow;
# ABSTRACT: Bindings for Libtensorflow deep learning library

use strict;
use warnings;

use AI::TensorFlow::Libtensorflow::Lib;

use AI::TensorFlow::Libtensorflow::DataType;
use AI::TensorFlow::Libtensorflow::Status;
use AI::TensorFlow::Libtensorflow::TString;

use AI::TensorFlow::Libtensorflow::Buffer;
use AI::TensorFlow::Libtensorflow::Tensor;

use AI::TensorFlow::Libtensorflow::Operation;
use AI::TensorFlow::Libtensorflow::Output;
use AI::TensorFlow::Libtensorflow::Input;

use AI::TensorFlow::Libtensorflow::ApiDefMap;
use AI::TensorFlow::Libtensorflow::TFLibrary;

use AI::TensorFlow::Libtensorflow::ImportGraphDefOptions;
use AI::TensorFlow::Libtensorflow::ImportGraphDefResults;
use AI::TensorFlow::Libtensorflow::Graph;

use AI::TensorFlow::Libtensorflow::OperationDescription;

use AI::TensorFlow::Libtensorflow::SessionOptions;
use AI::TensorFlow::Libtensorflow::Session;
use AI::TensorFlow::Libtensorflow::DeviceList;

use AI::TensorFlow::Libtensorflow::Eager::ContextOptions;
use AI::TensorFlow::Libtensorflow::Eager::Context;

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

1;
__END__

=pod

=head1 SYNOPSIS

  use aliased 'AI::TensorFlow::Libtensorflow' => 'Libtensorflow';

=head1 DESCRIPTION

The C<libtensorflow> library provides low-level C bindings
for TensorFlow with a stable ABI.

For more detailed information about this library including how to get started,
see L<AI::TensorFlow::Libtensorflow::Manual>.

=cut

=begin :badges

=for html
<a href="https://mybinder.org/v2/gh/EntropyOrg/perl-AI-TensorFlow-Libtensorflow/master"><img src="https://mybinder.org/badge_logo.svg" alt="Binder" /></a>
<a href="https://quay.io/repository/entropyorg/perl-ai-tensorflow-libtensorflow"><img src="https://img.shields.io/badge/quay.io-images-red.svg" alt="quay.io images" /></a>


=end :badges
