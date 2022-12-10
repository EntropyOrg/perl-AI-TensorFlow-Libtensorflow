package AI::TensorFlow::Libtensorflow::Input;
# ABSTRACT: Input of operation as (operation, index) pair

# See L<AI::TensorFlow::Libtensorflow::Output> for similar.
# In fact, they are mostly the same, but keeping the classes separate for now
# in case the upstream API changes.

use namespace::autoclean;
use FFI::Platypus::Record;
use AI::TensorFlow::Libtensorflow::Lib::FFIType::Variant::RecordArrayRef;

use AI::TensorFlow::Libtensorflow::Lib;
my $ffi = AI::TensorFlow::Libtensorflow::Lib->ffi;
$ffi->mangler(AI::TensorFlow::Libtensorflow::Lib->mangler_default);

record_layout_1($ffi,
	'opaque' => '_oper',   # 8 (on 64-bit)
	'int'    => '_index',  # 4

	$ffi->sizeof('opaque') == 8 ? (
		'char[4]' => ':',
	) : (),
);
$ffi->type('record(AI::TensorFlow::Libtensorflow::Input)', 'TF_Input');

sub New {
	my ($class, $args) = @_;

	my $record = $class->new({
		_oper => $ffi->cast( 'TF_Operation', 'opaque', delete $args->{oper} ),
		_index => delete $args->{index},
	});
}

sub oper  { $ffi->cast('opaque', 'TF_Operation', $_[0]->_oper ) }
sub index { $_[0]->_index }

$ffi->load_custom_type(
	RecordArrayRef( 'InputArrayPtr',
		record_module => __PACKAGE__, with_size => 0,
	),
	=> 'TF_Input_array');
$ffi->load_custom_type(
	RecordArrayRef( 'InputArrayPtrSz',
		record_module => __PACKAGE__, with_size => 1,
	),
	=> 'TF_Input_array_sz');

1;
