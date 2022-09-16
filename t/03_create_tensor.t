#!/usr/bin/env perl

use Test::More tests => 1;

use strict;
use warnings;

use lib 't/lib';
use TF_Utils;

use AI::TensorFlow::Libtensorflow;
use PDL;

subtest "Create a tensor" => sub {
	my $p_data = sequence(float, 1, 5, 12);
	my $tensor = TF_Utils::FloatPDLToTensor($p_data);
	pass;
};

done_testing;
