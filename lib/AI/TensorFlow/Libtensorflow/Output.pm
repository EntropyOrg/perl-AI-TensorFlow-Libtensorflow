package AI::TensorFlow::Libtensorflow::Output;
# ABSTRACT: Output of operation as (operation, index) pair

# See L<AI::TensorFlow::Libtensorflow::Input> for similar.
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

use FFI::C::ArrayDef;
use FFI::C::StructDef;
my $sdef = FFI::C::StructDef->new($ffi,
	name     => 'TF_Output_struct',
	members  => [
		_oper  => 'opaque',
		_index => 'int',
		__ignore => 'char[4]',
	],
);
my $adef = FFI::C::ArrayDef->new($ffi,
       name => 'TF_Output_struct_array',
       members => [ 'TF_Output_struct' ]
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

$ffi->load_custom_type(
	RecordArrayRef( 'OutputArrayPtr',
		record_module => __PACKAGE__, with_size => 0,
	),
	=> 'TF_Output_array');
$ffi->load_custom_type(
	RecordArrayRef( 'OutputArrayPtrSz',
		record_module => __PACKAGE__, with_size => 1,
	),
	=> 'TF_Output_array_sz');

1;
