package AI::TensorFlow::Libtensorflow::ApiDefMap;
# ABSTRACT: Maps Operation to API description

use namespace::autoclean;
use AI::TensorFlow::Libtensorflow::Lib qw(arg);

my $ffi = AI::TensorFlow::Libtensorflow::Lib->ffi;
$ffi->mangler(AI::TensorFlow::Libtensorflow::Lib->mangler_default);

=construct New

  use AI::TensorFlow::Libtensorflow;
  use aliased 'AI::TensorFlow::Libtensorflow::Status';

  my $map = ApiDefMap->New(
    AI::TensorFlow::Libtensorflow->GetAllOpList,
    my $status = Status->New
  );
  ok $map, 'Created ApiDefMap';

=tf_capi TF_NewApiDefMap

=cut
$ffi->attach( [ 'NewApiDefMap' => 'New' ] => [
	arg 'TF_Buffer' => 'op_list_buffer',
	arg 'TF_Status' => 'status',
] => 'TF_ApiDefMap' => sub {
	my ($xs, $class, @rest) = @_;
	$xs->(@rest);
});

=destruct DESTROY

=tf_capi TF_DeleteApiDefMap

=cut
$ffi->attach( ['DeleteApiDefMap' => 'DESTROY'] => [
	arg 'TF_ApiDefMap' => 'apimap'
] => 'void');

=method Put

TODO

=tf_capi TF_ApiDefMapPut

=cut
$ffi->attach( [ 'ApiDefMapPut' => 'Put' ] => [
	arg 'TF_ApiDefMap' => 'api_def_map',
	arg 'tf_text_buffer' => [qw(text text_len)],
	arg 'TF_Status' => 'status',
] => 'void' );

=method Get

=tf_capi TF_ApiDefMapGet

=cut
$ffi->attach( ['ApiDefMapGet' => 'Get' ] => [
	arg 'TF_ApiDefMap' => 'api_def_map',
	arg 'tf_text_buffer'  => [qw(name name_len)],
	arg 'TF_Status' => 'status',
] => 'TF_Buffer');

1;
__END__
=head1 SYNOPSIS

  use aliased 'AI::TensorFlow::Libtensorflow::ApiDefMap' => 'ApiDefMap';

=cut
