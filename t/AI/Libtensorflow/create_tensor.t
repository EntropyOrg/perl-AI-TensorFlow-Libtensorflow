#!/usr/bin/env perl

use Test::More tests => 1;

use strict;
use warnings;

use lib 't/lib';

use AI::Libtensorflow;
use PDL;
use PDL::Core ':Internal';

use FFI::Platypus::Buffer;

subtest "Create a tensor" => sub {
	my $ffi = FFI::Platypus->new( api => 1 );
	my $pdl_closure = $ffi->closure( sub {
		my ($pointer, $size, $pdl_addr) = @_;
		# noop
	});

	my $p_data = sequence(float, 1, 5, 12);
	my $p_dataref = $p_data->get_dataref;
	my ($p_pointer, $p_size) = scalar_to_buffer $$p_dataref;
	AI::Libtensorflow::Tensor->_New(
		AI::Libtensorflow::DType::FLOAT,
		[ $p_data->dims ], $p_data->ndims,
		$p_pointer, $p_size,
		$pdl_closure, \$p_data,
	);

	pass;
};

done_testing;
