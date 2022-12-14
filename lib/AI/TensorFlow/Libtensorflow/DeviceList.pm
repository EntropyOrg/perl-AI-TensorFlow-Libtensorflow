package AI::TensorFlow::Libtensorflow::DeviceList;
# ABSTRACT: A list of devices available for the session to run on

use namespace::autoclean;
use AI::TensorFlow::Libtensorflow::Lib qw(arg);

my $ffi = AI::TensorFlow::Libtensorflow::Lib->ffi;
$ffi->mangler(AI::TensorFlow::Libtensorflow::Lib->mangler_default);

=destruct DESTROY

=tf_capi TF_DeleteDeviceList

=cut
$ffi->attach( [ 'DeleteDeviceList' => 'DESTROY' ] => [
	arg TF_DeviceList => 'list',
] => 'void' );

=attr Count

=tf_capi TF_DeviceListCount

=cut
$ffi->attach( [ 'DeviceListCount' => 'Count' ] => [
	arg TF_DeviceList => 'list',
] => 'int' );

=method Name

=tf_capi TF_DeviceListName

=method Type

=tf_capi TF_DeviceListType

=method MemoryBytes

=tf_capi TF_DeviceListMemoryBytes

=method Incarnation

=tf_capi TF_DeviceListIncarnation

=cut
my %methods = (
	Name        => 'string',
	Type        => 'string',
	MemoryBytes => 'int64_t',
	Incarnation => 'uint64_t',
);
for my $method (keys %methods) {
	$ffi->attach( [ "DeviceList${method}" => $method ] => [
		arg TF_DeviceList => 'list',
		arg int => 'index',
		arg TF_Status => 'status'
	] => $methods{$method} );
}

### From tensorflow/core/framework/types.cc
my %DEVICE_TYPES = (
	DEFAULT => "DEFAULT",
	CPU => "CPU",
	GPU => "GPU",
	TPU => "TPU",
	TPU_SYSTEM => "TPU_SYSTEM",
);

1;
