#!/usr/bin/env perl

use Test2::V0;
use lib 't/lib';
use TF_TestQuiet;
use aliased 'AI::TensorFlow::Libtensorflow';

subtest "(CAPI, Session_Min_CPU)" => sub {
	pass;
};

done_testing;