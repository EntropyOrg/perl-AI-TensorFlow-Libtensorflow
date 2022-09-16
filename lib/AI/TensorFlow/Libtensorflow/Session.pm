package AI::TensorFlow::Libtensorflow::Session;

use AI::TensorFlow::Libtensorflow;
my $ffi = AI::TensorFlow::Libtensorflow::Lib->ffi;
$ffi->mangler(AI::TensorFlow::Libtensorflow::Lib->mangler_default);

# C: TF_NewSession
$ffi->attach( [ 'NewSession' => '_New' ] =>
	[ 'TF_Graph', 'TF_SessionOptions', 'TF_Status' ],
	=> 'TF_Session' => sub {
		my ($xs, $class, @rest) = @_;
		return $xs->(@rest);
	});
# C: TF_SessionRun
$ffi->attach( [ 'SessionRun' => 'Run' ] =>
	[ 'TF_Session',
	'TF_Buffer',
	'TF_Output', 'TF_Tensor', 'int',
	'TF_Output', 'TF_Tensor', 'int',
	'opaque', 'int',
	'opaque',
	'TF_Status',
	],
	=> 'void' );
# C: TF_CloseSession
$ffi->attach( [ 'CloseSession' => 'Close' ] =>
	[ 'TF_Session',
	'TF_Status',
	],
	=> 'void' );

1;
