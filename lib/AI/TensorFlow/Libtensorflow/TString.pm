package AI::TensorFlow::Libtensorflow::TString;
# ABSTRACT: A variable-capacity string type

use strict;
use warnings;
use namespace::autoclean;
use AI::TensorFlow::Libtensorflow::Lib qw(arg);
use FFI::Platypus::Memory qw(malloc free);

my $ffi = AI::TensorFlow::Libtensorflow::Lib->ffi;
$ffi->mangler(AI::TensorFlow::Libtensorflow::Lib->mangler_default);

### From <tensorflow/tsl/platform/ctstring_internal.h>
#// _Static_assert(sizeof(TF_TString) == 24);
use constant SIZEOF_TF_TString => 24;


### From <tensorflow/tsl/platform/ctstring_internal.h>
# typedef enum TF_TString_Type {  // NOLINT
#   TF_TSTR_SMALL = 0x00,
#   TF_TSTR_LARGE = 0x01,
#   TF_TSTR_OFFSET = 0x02,
#   TF_TSTR_VIEW = 0x03,
#   TF_TSTR_TYPE_MASK = 0x03
# } TF_TString_Type;

sub _CREATE {
	my ($class) = @_;
	my $pointer = malloc SIZEOF_TF_TString;
	my $obj = bless { ptr => $pointer }, $class;
}

=construct Init

  my $tstr = TString->Init;

=tf_capi TF_StringInit

=cut
$ffi->attach( [ 'StringInit' => 'Init' ] => [
	arg 'TF_TString' => 'tstr'
] => 'void' => sub {
	my ($xs, $invoc) = @_;
	my $obj = ref $invoc ? $invoc : $invoc->_CREATE();
	$xs->($obj);
	$obj;
});

=method Copy

=tf_capi TF_StringCopy

=cut
$ffi->attach( [ 'StringCopy' => 'Copy' ] => [
	arg TF_TString => 'dst',
	arg tf_text_buffer => [ qw( src size ) ],
] => 'void' );

=method AssignView

=tf_capi TF_StringAssignView

=cut
$ffi->attach( [ 'StringAssignView' => 'AssignView' ] => [
	arg TF_TString => 'dst',
	arg tf_text_buffer => [ qw( src size ) ],
] => 'void' );

=method GetDataPointer

TODO API question: Should this be an opaque or a window()?

=tf_capi TF_StringGetDataPointer

=cut
$ffi->attach( [ 'StringGetDataPointer' => 'GetDataPointer' ] => [
	arg TF_TString => 'tstr',
] => 'opaque' );

=method GetType

TODO API question: Add enum for TF_TString_Type return type?

=tf_capi TF_StringGetType

=cut
$ffi->attach( [ 'StringGetType' => 'GetType' ] => [
	arg TF_TString => 'str'
] => 'int' );

=method GetSize

=tf_capi TF_StringGetSize

=cut
$ffi->attach( [ 'StringGetSize' => 'GetSize' ] => [
	arg TF_TString => 'tstr'
] => 'size_t' );

=method GetCapacity

=tf_capi TF_StringGetCapacity

=cut
$ffi->attach( [ 'StringGetCapacity' => 'GetCapacity' ] => [
	arg TF_TString => 'str'
] => 'size_t' );

=method Dealloc

=tf_capi TF_StringDealloc

=cut
$ffi->attach( [ 'StringDealloc' => 'Dealloc' ] => [
	arg TF_TString => 'tstr',
] => 'void' );

sub DESTROY {
	if( ! $_[0]->{owner} ) {
		$_[0]->Dealloc;
		free $_[0]->{ptr};
	}
}

1;
__END__
=head1 SYNOPSIS

  use aliased 'AI::TensorFlow::Libtensorflow::TString';

=cut
