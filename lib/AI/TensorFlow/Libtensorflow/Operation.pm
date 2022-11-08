package AI::TensorFlow::Libtensorflow::Operation;
# ABSTRACT: An operation

use namespace::autoclean;
use AI::TensorFlow::Libtensorflow::Lib qw(arg);

my $ffi = AI::TensorFlow::Libtensorflow::Lib->ffi;
$ffi->mangler(AI::TensorFlow::Libtensorflow::Lib->mangler_default);

use FFI::C::ArrayDef;
my $adef = FFI::C::ArrayDef->new(
	$ffi,
	name => 'TF_Operation_array',
	members => [
		FFI::C::StructDef->new(
			$ffi,
			members => [
				p => 'opaque'
			]
		)
	],
);
sub _adef {
	$adef;
}
sub _as_array {
	my $class = shift;
	my $array = $class->_adef->create(0 + @_);
	for my $idx (0..@_-1) {
		next unless defined $_[$idx];
		$array->[$idx]->p($ffi->cast('TF_Operation', 'opaque', $_[$idx]));
	}
	$array;
}

1;
