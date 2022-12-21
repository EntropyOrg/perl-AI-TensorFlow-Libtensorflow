package AI::TensorFlow::Libtensorflow::TFLibrary;
# ABSTRACT: TensorFlow dynamic library handle and ops

use strict;
use warnings;

use AI::TensorFlow::Libtensorflow::Lib qw(arg);
my $ffi = AI::TensorFlow::Libtensorflow::Lib->ffi;

=construct LoadLibrary

=tf_capi TF_LoadLibrary

=cut
$ffi->attach( [ 'LoadLibrary' => 'LoadLibrary' ] => [
	arg string => 'library_filename',
	arg TF_Status => 'status',
] => 'TF_Library' => sub {
	my ($xs, $class, @rest) = @_;
	$xs->(@rest);
} );

=method GetOpList

=tf_capi TF_GetOpList

=cut
$ffi->attach( [ 'GetOpList' => 'GetOpList' ] => [
	arg TF_Library => 'lib_handle'
] => 'TF_Buffer' );

=destruct DESTROY

=tf_capi TF_DeleteLibraryHandle

=cut
$ffi->attach( [ 'DeleteLibraryHandle' => 'DESTROY' ] => [
	arg TF_Library => 'lib_handle'
] => 'void' );

=classmethod GetAllOpList

=for :signature
GetAllOpList()

  my $buf = AI::TensorFlow::Libtensorflow::TFLibrary->GetAllOpList();
  cmp_ok $buf->length, '>', 0, 'Got OpList buffer';

=for :returns
= TFBuffer
Contains a serialized C<OpList> proto for ops registered in this address space.

=tf_capi TF_GetAllOpList

=cut
$ffi->attach( 'GetAllOpList' => [], 'TF_Buffer' );


1;
