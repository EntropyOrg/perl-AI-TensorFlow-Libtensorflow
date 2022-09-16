package AI::TensorFlow::Libtensorflow::ImportGraphDefOptions;

use AI::TensorFlow::Libtensorflow::Lib;
my $ffi = AI::TensorFlow::Libtensorflow::Lib->ffi;
$ffi->mangler(AI::TensorFlow::Libtensorflow::Lib->mangler_default);

$ffi->attach( [ 'NewImportGraphDefOptions' => '_New' ] => [] => 'TF_ImportGraphDefOptions' );

$ffi->attach( [ 'DeleteImportGraphDefOptions' => '_Delete' ] => [] => 'TF_ImportGraphDefOptions' );

1;
