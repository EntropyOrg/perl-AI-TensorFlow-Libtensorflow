#!/usr/bin/env perl

use Test2::V0;
use lib 't/lib';
use TF_TestQuiet;
use TF_Utils;
use aliased 'AI::TensorFlow::Libtensorflow';
use AI::TensorFlow::Libtensorflow::DataType qw(INT32);

subtest "(CAPI, Graph)" => sub {
	pass;
	my $s = AI::TensorFlow::Libtensorflow::Status->New;
	my $graph = AI::TensorFlow::Libtensorflow::Graph->New;

	note 'Make a placeholder operation.';
	my $feed = TF_Utils::Placeholder($graph, $s);
	TF_Utils::AssertStatusOK($s);

	note 'Test TF_Operation*() query functions.';
	is $feed->Name, 'feed', 'name';
	is $feed->OpType, 'Placeholder', 'optype';
	is $feed->Device, '', 'device';
	is $feed->NumOutputs, 1, 'num outputs';
	cmp_ok $feed->OutputType(
		AI::TensorFlow::Libtensorflow::Output->New({oper => $feed, index => 0})
	), 'eq', INT32, 'output 0 type';
	is $feed->OutputListLength("output", $s), 1, 'output list length';
	TF_Utils::AssertStatusOK($s);
	is $feed->NumInputs, 0, 'num inputs';
	is $feed->OutputNumConsumers(
		AI::TensorFlow::Libtensorflow::Output->New({oper => $feed, index => 0})
	), 0, 'output 0 num consumers';
	is $feed->NumControlInputs, 0, 'num control inputs';
	is $feed->NumControlOutputs, 0, 'num control outputs';


	note 'Test not found errors in TF_Operation*() query functions.';
	is $feed->OutputListLength('bogus', $s), -1, 'bogus output';
	note TF_Utils::AssertStatusNotOK($s);

	note 'Make a constant oper with the scalar "3".';
	my $three = TF_Utils::ScalarConst($graph, $s, 'scalar', INT32, 3);
	TF_Utils::AssertStatusOK($s);

	note 'Add oper.';
	my $add = TF_Utils::Add($feed, $three, $graph, $s);
	TF_Utils::AssertStatusOK($s);

	note 'Test TF_Operation*() query functions.';
	is $add->Name, 'add', 'name';
	is $add->OpType, 'AddN', 'op type';
	is $add->Device, '', 'device';
	is $add->NumOutputs, 1, 'num outputs';
};

done_testing;
