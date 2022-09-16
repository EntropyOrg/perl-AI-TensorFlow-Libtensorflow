package AI::TensorFlow::Libtensorflow::Graph;

use AI::TensorFlow::Libtensorflow::Lib;
my $ffi = AI::TensorFlow::Libtensorflow::Lib->ffi;
$ffi->mangler(AI::TensorFlow::Libtensorflow::Lib->mangler_default);

$ffi->attach( [ 'NewGraph' => '_New' ] => [] => 'TF_Graph' );

$ffi->attach( [ 'DeleteGraph' => '_Delete' ] => [ 'TF_Graph' ], 'void' );

$ffi->attach( [ 'GraphImportGraphDef'  => 'ImportGraphDef'  ] => [ 'TF_Graph', 'TF_Buffer', 'TF_ImportGraphDefOptions', 'TF_Status' ], 'void' );
$ffi->attach( [ 'GraphOperationByName' => 'OperationByName' ] => [ 'TF_Graph', 'string' ], 'TF_Operation' );

1;
