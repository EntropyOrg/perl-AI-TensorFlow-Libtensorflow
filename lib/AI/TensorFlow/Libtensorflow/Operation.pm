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

1;
