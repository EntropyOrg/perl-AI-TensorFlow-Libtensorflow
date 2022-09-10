#!/usr/bin/env perl

use Test::More tests => 1;

use lib 't/lib';

use AI::TensorFlow::Libtensorflow;

subtest "Get version of Tensorflow" => sub {
	my $tf = AI::TensorFlow::Libtensorflow->new;
	note $tf->version;
	pass;
};

done_testing;
