package AI::TensorFlow::Libtensorflow::Output;
# ABSTRACT: Operation and index pair

use namespace::autoclean;
use FFI::Platypus::Record;

use AI::TensorFlow::Libtensorflow::Lib;
my $ffi = AI::TensorFlow::Libtensorflow::Lib->ffi;
$ffi->mangler(AI::TensorFlow::Libtensorflow::Lib->mangler_default);

record_layout_1($ffi,
	'opaque' => '_oper',   # 8 (on 64-bit)
	'int'    => '_index',  # 4

	# padding to make sizeof(record) == 16
	# but only on machines where sizeof(opaque) is 8 bytes
	# See also:
	#   Convert::Binary::C->new( Alignment => 8 )
	#     ->parse( ... )
	#     ->sizeof( ... )
	$ffi->sizeof('opaque') == 8 ? (
		'char[4]' => ':',
	) : (),
);
$ffi->type('record(AI::TensorFlow::Libtensorflow::Output)', 'TF_Output');

sub New {
	my ($class, $args) = @_;

	my $record = $class->new({
		_oper => $ffi->cast( 'TF_Operation', 'opaque', delete $args->{oper} ),
		_index => delete $args->{index},
	});
}

sub oper  { $ffi->cast('opaque', 'TF_Operation', $_[0]->_oper ) }
sub index { $_[0]->_index }

$ffi->load_custom_type('AI::TensorFlow::Libtensorflow::Lib::FFIType::TFOutputArrayPtr' => 'TF_Output_array');

1;
