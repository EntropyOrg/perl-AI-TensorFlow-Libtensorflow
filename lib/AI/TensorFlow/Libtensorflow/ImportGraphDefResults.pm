package AI::TensorFlow::Libtensorflow::ImportGraphDefResults;
# ABSTRACT: Results from importing a graph definition

use namespace::autoclean;
use AI::TensorFlow::Libtensorflow::Lib qw(arg);
use FFI::Platypus::Buffer qw(buffer_to_scalar window);

my $ffi = AI::TensorFlow::Libtensorflow::Lib->ffi;
$ffi->mangler(AI::TensorFlow::Libtensorflow::Lib->mangler_default);

=destruct DESTROY

=tf_capi TF_DeleteImportGraphDefResults

=cut
$ffi->attach( [ 'DeleteImportGraphDefResults' => 'DESTROY' ] => [
	arg TF_ImportGraphDefResults => 'results',
] => 'void' );

=method ReturnOutputs

=tf_capi TF_ImportGraphDefResultsReturnOutputs

=cut
$ffi->attach( [ 'ImportGraphDefResultsReturnOutputs' => 'ReturnOutputs' ] => [
	arg TF_ImportGraphDefResults => 'results',
	arg 'int*' => 'num_outputs',
	arg 'opaque*' => { id => 'outputs', type => 'TF_Output_struct_array*' },
] => 'void' => sub {
	my ($xs, $results) = @_;
	my $num_outputs;
	my $outputs_array = undef;
	$xs->($results, \$num_outputs, \$outputs_array);
	return [] if $num_outputs == 0;

	my $sizeof_output = $ffi->sizeof('TF_Output');
	window(my $outputs_packed, $outputs_array, $sizeof_output * $num_outputs );
	# due to unpack, these are copies (no longer owned by $results)
	my @outputs = map bless(\$_, "AI::TensorFlow::Libtensorflow::Output"),
		unpack "(a${sizeof_output})*", $outputs_packed;
	return \@outputs;
});

=method ReturnOperations

=tf_capi TF_ImportGraphDefResultsReturnOperations

=cut
$ffi->attach( [ 'ImportGraphDefResultsReturnOperations' => 'ReturnOperations' ] => [
	arg TF_ImportGraphDefResults => 'results',
	arg 'int*' => 'num_opers',
	arg 'opaque*' => { id => 'opers', type => 'TF_Operation_array*' },
] => 'void' => sub {
	my ($xs, $results) = @_;
	my $num_opers;
	my $opers_array = undef;
	$xs->($results, \$num_opers, \$opers_array);
	return [] if $num_opers == 0;

	my $opers_array_base_packed = buffer_to_scalar($opers_array,
		$ffi->sizeof('opaque') * $num_opers );
	my @opers = map {
		$ffi->cast('opaque', 'TF_Operation', $_ )
	} unpack "(@{[ AI::TensorFlow::Libtensorflow::Lib::_pointer_incantation ]})*", $opers_array_base_packed;
	return \@opers;
} );

1;
