package AI::TensorFlow::Libtensorflow::Status;
# ABSTRACT: Status

use AI::TensorFlow::Libtensorflow::Lib;
use FFI::C;

my $ffi = AI::TensorFlow::Libtensorflow::Lib->ffi;
$ffi->mangler(sub {
	my($name) = @_;
	"TF_$name";
});

# enum TF_Code {{{
# From <tensorflow/c/tf_status.h>
$ffi->load_custom_type('::Enum', 'TF_Code',
	OK                  => 0,
	CANCELLED           => 1,
	UNKNOWN             => 2,
	INVALID_ARGUMENT    => 3,
	DEADLINE_EXCEEDED   => 4,
	NOT_FOUND           => 5,
	ALREADY_EXISTS      => 6,
	PERMISSION_DENIED   => 7,
	UNAUTHENTICATED     => 16,
	RESOURCE_EXHAUSTED  => 8,
	FAILED_PRECONDITION => 9,
	ABORTED             => 10,
	OUT_OF_RANGE        => 11,
	UNIMPLEMENTED       => 12,
	INTERNAL            => 13,
	UNAVAILABLE         => 14,
	DATA_LOSS           => 15,
);#}}}

$ffi->attach( [ 'NewStatus' => '_New' ] => [] => 'TF_Status' );
$ffi->attach( 'GetCode' => [ 'TF_Status' ], 'TF_Code' );
$ffi->attach( [ 'DeleteStatus' => '_Delete' ] => [ 'TF_Status' ], 'void' );

1;
