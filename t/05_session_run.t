#!/usr/bin/env perl

use Test::Most tests => 1;

use lib 't/lib';
use TF_Utils;
use PDL::Primitive qw(random);
use PDL::Core;

use FFI::Platypus::Buffer;

subtest "Session run" => sub {
	my $graph = TF_Utils::LoadGraph('t/models/graph.pb');
	ok $graph, 'graph';
	my $input_op = AI::TensorFlow::Libtensorflow::Output->new( { oper => $graph->OperationByName( 'input_4' ), index => 0 } );
	die "Can not init input op" unless $input_op;

	my $ffi = FFI::Platypus->new( api => 1 );
	my $pdl_closure = $ffi->closure( sub {
		my ($pointer, $size, $pdl_addr) = @_;
		# noop
	});
	my $p_data = random(float, 1, 5, 12);
	my $p_dataref = $p_data->get_dataref;
	my ($p_pointer, $p_size) = scalar_to_buffer $$p_dataref;
	my $input_tensor = AI::TensorFlow::Libtensorflow::Tensor->_New(
		AI::TensorFlow::Libtensorflow::DType::FLOAT,
		[ $p_data->dims ], $p_data->ndims,
		$p_pointer, $p_size,
		$pdl_closure, \$p_data,
	);

	my $output_tensor = undef;

	my $output_op = AI::TensorFlow::Libtensorflow::Output->new( { oper => $graph->OperationByName( 'output_node0') , index => 0 } );
	die "Can not init output op" unless $output_op;

	my $status = AI::TensorFlow::Libtensorflow::Status->_New;
	my $options = AI::TensorFlow::Libtensorflow::SessionOptions->_New;
	my $session = AI::TensorFlow::Libtensorflow::Session->_New($graph, $options, $status);
	die "Could not create session" unless $status->GetCode eq 'OK';

	my $in_op_a = AI::TensorFlow::Libtensorflow::Output_Array->new( 1, [$input_op] );
	my $in_tr_a = [$input_tensor];
	my $out_op_a = AI::TensorFlow::Libtensorflow::Output_Array->new(1, [$output_op]);
	my $out_tr_a = [\$output_tensor];
	$session->Run(
		undef,
		\$in_op_a, \$in_tr_a, 1,
		\$out_op_a, \$out_tr_a, 1,
		undef, 0,
		undef,
		$status
	);
	die "run failed" unless $status->GetCode eq 'OK';

	$session->Close($status);
	pass;
};

done_testing;
