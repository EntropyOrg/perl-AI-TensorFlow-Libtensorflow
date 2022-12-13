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


use AI::TensorFlow::Libtensorflow::Lib::Types qw(TFOutput TFOutputFromTuple);
use Types::Standard qw(HashRef);

my $TFOutput = TFOutput->plus_constructors(
		HashRef, 'New'
	)->plus_coercions(TFOutputFromTuple);
sub Add {
	my ($l, $r, $graph, $s, $name) = @_;
	$name ||= 'add';
	my $desc = AI::TensorFlow::Libtensorflow::OperationDescription->New(
		$graph, "AddN", $name);
	$desc->AddInputList([
		$TFOutput->map( [ $l => 0 ], [ $r => 0 ] )
	]);
	my $op = $desc->FinishOperation($s);
	AssertStatusOK($s);
	$op;
}

sub Neg {
	my ($n, $graph, $s, $name) = @_;
	$name ||= 'neg';
	my $desc = AI::TensorFlow::Libtensorflow::OperationDescription->New(
		$graph, "Neg", $name);
	my $neg_input = $TFOutput->coerce([$n => 0]);
	$desc->AddInput($neg_input);
	my $op = $desc->FinishOperation($s);
	AssertStatusOK($s);
	$op;
}


sub Int32Tensor {
	my ($v) = @_;
	my $t = AI::TensorFlow::Libtensorflow::Tensor->Allocate( INT32, [] );
	memcpy scalar_to_pointer( ${ $t->Data } ),
		scalar_to_pointer(pack("l", $v)), INT32->Size;
	return $t;
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

package # hide from PAUSE
  TF_Utils::CSession {

	use Class::Tiny qw(
		session
		graph use_XLA
		_inputs _input_values
		_outputs _output_values
		_targets
	), {
		use_XLA => sub { 0 },
	};

  sub BUILD {
	my ($self, $args) = @_;
	my $s = delete $args->{status};
	my $opts = AI::TensorFlow::Libtensorflow::SessionOptions->New;
	$opts->EnableXLACompilation( $self->use_XLA );
	$self->session( AI::TensorFlow::Libtensorflow::Session->New( $self->graph, $opts, $s ) );
  }

  sub SetInputs {
	my ($self, @data) = @_;
	my (@inputs, @input_values);
	for my $pair (@data) {
		my ($oper, $t) = @$pair;
		push @inputs, AI::TensorFlow::Libtensorflow::Output->New({ oper => $oper, index => 0 });
		push @input_values, $t;
	}
	$self->_inputs( \@inputs );
	$self->_input_values( \@input_values );
  }

  sub SetOutputs {
	my ($self, @data) = @_;
	my @outputs;
	my @output_values;
	for my $oper (@data) {
		push @outputs, AI::TensorFlow::Libtensorflow::Output->New({ oper => $oper, index => 0 });
	}
	$self->_outputs( \@outputs );
	$self->_output_values( \@output_values );
  }

  sub SetTargets {
	my ($self, @data) = @_;
	$self->_targets( \@data );
  }

  sub Run {
	my ($self, $s) = @_;
	if( @{ $self->_inputs } != @{ $self->_input_values } ) {
		die "Call SetInputs() before Run()";
	}

	$self->session->Run(
		undef,
		$self->_inputs, $self->_input_values,
		$self->_outputs, $self->_output_values,
		$self->_targets,
		undef,
		$s
	);
  }

  sub output_tensor { my ($self, $i) = @_; $self->_output_values->[$i] }
}

1;
