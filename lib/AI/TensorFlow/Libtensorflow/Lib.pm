package AI::TensorFlow::Libtensorflow::Lib;
# ABSTRACT: Private class for AI::TensorFlow::Libtensorflow

use strict;
use warnings;

use feature qw(state);
use FFI::CheckLib 0.28 qw( find_lib_or_die );
use Alien::Libtensorflow;
use FFI::Platypus;

sub lib {
	find_lib_or_die(
		lib => 'tensorflow',
		symbol => ['TF_Version'],
		alien => ['Alien::Libtensorflow'] );
}

sub ffi {
	state $ffi;
	$ffi ||= do {
		my $ffi = FFI::Platypus->new( api => 2 );
		$ffi->lib( __PACKAGE__->lib );

		$ffi->load_custom_type('::PtrObject', 'TF_Tensor' => 'AI::TensorFlow::Libtensorflow::Tensor');

		$ffi->type('opaque' => 'TF_Operation');
		$ffi->type('object(AI::TensorFlow::Libtensorflow::Status)' => 'TF_Status');
		#$ffi->type('object(AI::TensorFlow::Libtensorflow::Operation)' => 'TF_Operation');

		# callbacks for deallocation
		$ffi->type('(opaque,size_t)->void'        => 'data_deallocator_t');
		$ffi->type('(opaque,size_t,opaque)->void' => 'tensor_deallocator_t');

		$ffi;
	};
}

sub mangler_default {
	sub {
		my ($name) = @_;
		"TF_$name";
	}
}

sub mangler_for_object {
	my ($class, $object_name) = @_;
	sub {
		my ($name) = @_;

		# constructor and destructors
		return "TF_New${object_name}" if $name eq 'New';
		return "TF_Delete${object_name}" if $name eq 'Delete';

		return "TF_${object_name}$name";
	};
}

1;
