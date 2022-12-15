package AI::TensorFlow::Libtensorflow::Status;
# ABSTRACT: Status used for error checking

use namespace::autoclean;
use AI::TensorFlow::Libtensorflow::Lib;
use FFI::C;

my $ffi = AI::TensorFlow::Libtensorflow::Lib->ffi;
$ffi->mangler(AI::TensorFlow::Libtensorflow::Lib->mangler_default);

# enum TF_Code {{{
# From <tensorflow/c/tf_status.h>
$ffi->load_custom_type('::Enum', 'TF_Code',
	{ rev => 'int', package => __PACKAGE__ },
	[ OK                  => 0 ],
	[ CANCELLED           => 1 ],
	[ UNKNOWN             => 2 ],
	[ INVALID_ARGUMENT    => 3 ],
	[ DEADLINE_EXCEEDED   => 4 ],
	[ NOT_FOUND           => 5 ],
	[ ALREADY_EXISTS      => 6 ],
	[ PERMISSION_DENIED   => 7 ],
	[ UNAUTHENTICATED     => 16 ],
	[ RESOURCE_EXHAUSTED  => 8 ],
	[ FAILED_PRECONDITION => 9 ],
	[ ABORTED             => 10 ],
	[ OUT_OF_RANGE        => 11 ],
	[ UNIMPLEMENTED       => 12 ],
	[ INTERNAL            => 13 ],
	[ UNAVAILABLE         => 14 ],
	[ DATA_LOSS           => 15 ],
);#}}}

=begin TF_CAPI_EXPORT

TF_CAPI_EXPORT extern TF_Status* TF_NewStatus(void);

=end TF_CAPI_EXPORT

=cut
$ffi->attach( [ 'NewStatus' => 'New' ] => [] => 'TF_Status' );

=begin TF_CAPI_EXPORT

TF_CAPI_EXPORT extern void TF_DeleteStatus(TF_Status*);

=end TF_CAPI_EXPORT

=cut
$ffi->attach( [ 'DeleteStatus' => 'DESTROY' ] => [ 'TF_Status' ], 'void' );

=begin TF_CAPI_EXPORT

TF_CAPI_EXPORT extern void TF_SetStatus(TF_Status* s, TF_Code code,
                                        const char* msg);

=end TF_CAPI_EXPORT

=cut
$ffi->attach( 'SetStatus' => [ 'TF_Status', 'TF_Code', 'string' ], 'void' );

=begin TF_CAPI_EXPORT

TF_CAPI_EXPORT void TF_SetPayload(TF_Status* s, const char* key,
                                  const char* value);
=end TF_CAPI_EXPORT

=cut
$ffi->attach( 'SetPayload' => [ 'TF_Status', 'string', 'string' ], 'void' );

=begin TF_CAPI_EXPORT

TF_CAPI_EXPORT extern void TF_SetStatusFromIOError(TF_Status* s, int error_code,
                                                   const char* context);
=end TF_CAPI_EXPORT

=cut
$ffi->attach( 'SetStatusFromIOError' => [ 'TF_Status', 'int', 'string' ],
	'void' );

=begin TF_CAPI_EXPORT

TF_CAPI_EXPORT extern TF_Code TF_GetCode(const TF_Status* s);

=end TF_CAPI_EXPORT

=cut
$ffi->attach( 'GetCode' => [ 'TF_Status' ], 'TF_Code' );

=begin TF_CAPI_EXPORT

TF_CAPI_EXPORT extern const char* TF_Message(const TF_Status* s);

=end TF_CAPI_EXPORT

=cut
$ffi->attach( 'Message' => [ 'TF_Status' ], 'string' );

1;
