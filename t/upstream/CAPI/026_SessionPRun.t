#!/usr/bin/env perl

use Test2::V0;
use lib 't/lib';
use TF_TestQuiet;
use aliased 'AI::TensorFlow::Libtensorflow' => 'tf';

subtest "(CAPI, SessionPRun)" => sub {
	pass;
};

done_testing;
