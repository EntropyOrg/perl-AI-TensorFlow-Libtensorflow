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

	is $tensor->NumDims, 3, '3D TF_Tensor';

	is $tensor->Dim(0), 1 , 'dim[0] = 1';
	is $tensor->Dim(1), 5 , 'dim[1] = 5';
	is $tensor->Dim(2), 12, 'dim[2] = 12';

	pass;
};

done_testing;
