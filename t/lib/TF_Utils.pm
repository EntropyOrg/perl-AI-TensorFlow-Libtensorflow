package TF_Utils;

use AI::TensorFlow::Libtensorflow;
use AI::TensorFlow::Libtensorflow::Lib;
use AI::TensorFlow::Libtensorflow::DataType qw(FLOAT INT32);
use Path::Tiny;

use PDL::Core ':Internal';

use FFI::Platypus::Buffer;

my $ffi = AI::TensorFlow::Libtensorflow::Lib->ffi;

sub ScalarStringTensor {
	my ($str, $status) = @_;
	#my $tensor = AI::TensorFlow::Libtensorflow::Tensor->_Allocate(
		#AI::TensorFlow::Libtensorflow::DType::STRING,
		#\@dims, $ndims,
		#$data_size_bytes,
	#);
	...
}

sub ReadBufferFromFile {
	my ($path) = @_;
	my $data = path($path)->slurp_raw;
	my $buffer = AI::TensorFlow::Libtensorflow::Buffer->NewFromData(
		$data
	);
}

sub LoadGraph {
	my ($path, $checkpoint_prefix, $status) = @_;
	my $buffer = ReadBufferFromFile( $path );

	$status //= AI::TensorFlow::Libtensorflow::Status->New;

	my $graph = AI::TensorFlow::Libtensorflow::Graph->New;
	my $opts  = AI::TensorFlow::Libtensorflow::ImportGraphDefOptions->New;

	$graph->ImportGraphDef( $buffer, $opts, $status );

	if( $status->GetCode ne 'OK' ) {
		return undef;
	}

	if( ! defined $checkpoint_prefix ) {
		return $graph;
	}
}

sub FloatPDLToTFTensor {
	my ($p) = @_;
	my $pdl_closure = sub {
		my ($pointer, $size, $pdl_addr) = @_;
		# noop
	};

	my $p_dataref = $p->get_dataref;
	my $tensor = AI::TensorFlow::Libtensorflow::Tensor->New(
		FLOAT, [ $p->dims ], $p_dataref, $pdl_closure
	);

	$tensor;
}

sub Placeholder {
	my ($graph, $status, $name, $dtype) = @_;
	$name ||= 'feed';
	$dtype ||= INT32;
	my $desc = AI::TensorFlow::Libtensorflow::OperationDescription->New($graph, 'Placeholder', $name);
	$desc->SetAttrType('dtype', $dtype);
	my $op = $desc->FinishOperation($status);
	AssertStatusOK($status);
	$op;
}

sub Const {
	my ($graph, $status, $name, $dtype, $t) = @_;
	my $desc = AI::TensorFlow::Libtensorflow::OperationDescription->New($graph, 'Const', $name);
	$desc->SetAttrTensor('value', $t, $status);
	$desc->SetAttrType('dtype', $t->Type);
	my $op = $desc->FinishOperation($status);
	AssertStatusOK($status);
	$op;
}

my %dtype_to_pack = (
	FLOAT => 'f',
	DOUBLE => 'd',
	INT32  => 'l',
	BOOL => 'c',
);

use FFI::Platypus::Buffer qw(scalar_to_pointer);
use FFI::Platypus::Memory qw(memcpy);

sub ScalarConst {
	my ($graph, $status, $name, $dtype, $value) = @_;
	$name ||= 'scalar';
	my $t = AI::TensorFlow::Libtensorflow::Tensor->Allocate($dtype, []);
	die unless exists $dtype_to_pack{$dtype};
	my $data = pack $dtype_to_pack{$dtype} . '*', $value;
	memcpy scalar_to_pointer(${ $t->Data }),
		 scalar_to_pointer($data),
		 $t->ByteSize;
	return Const($graph, $status, $name, $dtype, $t);
}

sub Add {
	my ($l, $r, $graph, $s, $name) = @_;
	$name ||= 'add';
	my $desc = AI::TensorFlow::Libtensorflow::OperationDescription->New(
		$graph, "AddN", $name);
	my $add_inputs = [
		map {
			AI::TensorFlow::Libtensorflow::Output->New({
				oper => $_,
				index => 0,
			})
		} ($l, $r)
	];
	$desc->AddInputList($add_inputs);
	my $op = $desc->FinishOperation($s);
	AssertStatusOK($s);
	$op;
}

sub AssertStatusOK {
	my ($status) = @_;
	die "Status not OK: @{[ $status->GetCode ]} : @{[ $status->Message ]}"
		unless $status->GetCode eq 'OK';
}

sub AssertStatusNotOK {
	my ($status) = @_;
	die "Status expected not OK" if $status->GetCode eq 'OK';
	return "Status: @{[ $status->GetCode ]}:  @{[ $status->Message ]}";
}

1;
