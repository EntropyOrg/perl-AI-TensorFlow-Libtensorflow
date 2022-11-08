package AI::TensorFlow::Libtensorflow::Output;

use namespace::autoclean;
use FFI::C;

use AI::TensorFlow::Libtensorflow::Lib;
my $ffi = AI::TensorFlow::Libtensorflow::Lib->ffi;
$ffi->mangler(AI::TensorFlow::Libtensorflow::Lib->mangler_default);
FFI::C->ffi($ffi);

FFI::C->struct( 'TF_Output' => [
	_oper  => 'opaque',
	_index => 'int',
]);

sub New {
	my ($class, $args) = @_;
	my $struct = $class->new({
		_oper => $ffi->cast( 'TF_Operation', 'opaque', delete $args->{oper} ),
		_index => delete $args->{index},
	});
}

sub oper  { $ffi->cast('opaque', 'TF_Operation', $_[0]->_oper ) }
sub index { $_[0]->_index }

use FFI::C::ArrayDef;
my $adef = FFI::C::ArrayDef->new($ffi,
	name => 'TF_Output_array',
	members => [ 'TF_Output' ]
);
sub _adef { $adef; }
sub _as_array {
	my $class = shift;
	my $output = $class->_adef->create(0 + @_);
	for my $idx (0..@_-1) {
		next unless defined $_[$idx];
		$output->[$idx]->_oper ($_[$idx]->_oper);
		$output->[$idx]->_index($_[$idx]->_index);
	}
	$output;
}

1;
