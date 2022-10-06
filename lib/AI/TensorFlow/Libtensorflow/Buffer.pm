package AI::TensorFlow::Libtensorflow::Buffer;

use namespace::autoclean;
use AI::TensorFlow::Libtensorflow::Lib;

my $ffi = AI::TensorFlow::Libtensorflow::Lib->ffi;
$ffi->mangler(AI::TensorFlow::Libtensorflow::Lib->mangler_default);
FFI::C->ffi($ffi);

use FFI::Platypus::Buffer;
use FFI::Platypus::Memory;

FFI::C->struct( 'TF_Buffer' => [
	data => 'opaque',
	length => 'size_t',
	_data_deallocator => 'opaque', # data_deallocator_t
	# this does not work?
	#_data_deallocator => 'data_deallocator_t',
]);

sub data_deallocator {
	my ($self, $coderef) = shift;

	return $self->{_data_deallocator_closure} unless $coderef;

	my $closure = $ffi->closure( $coderef );

	$closure->sticky;
	$self->{_data_deallocator_closure} = $closure;

	my $opaque = $ffi->cast('data_deallocator_t', 'opaque', $closure);
	$self->_data_deallocator( $opaque );
}

$ffi->attach( [ 'NewBuffer' => '_New' ] => [] => 'TF_Buffer' );

sub NewFromData { # TODO look at Python high-level API
	my ($class, $data) = @_;

	my $buf = $class->_New;

	my ($pointer, $size) = scalar_to_buffer $data;

	$buf->data( $pointer );
	$buf->length( $size );
	$buf->data_deallocator(sub {
		my ($pointer, $size) = @_;
		free $pointer;
	});

	$buf;
}

$ffi->attach( [ 'DeleteBuffer' => '_Delete' ] => [ 'TF_Buffer' ], 'void' );

1;
