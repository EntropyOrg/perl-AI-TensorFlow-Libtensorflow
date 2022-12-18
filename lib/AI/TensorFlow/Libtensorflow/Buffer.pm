package AI::TensorFlow::Libtensorflow::Buffer;
# ABSTRACT: Buffer that holds pointer to data with length

use strict;
use warnings;
use namespace::autoclean;
use AI::TensorFlow::Libtensorflow::Lib qw(arg);

my $ffi = AI::TensorFlow::Libtensorflow::Lib->ffi;
$ffi->mangler(AI::TensorFlow::Libtensorflow::Lib->mangler_default);
use FFI::C;
FFI::C->ffi($ffi);
$ffi->load_custom_type('AI::TensorFlow::Libtensorflow::Lib::FFIType::TFPtrSizeScalarRef'
	=> 'tf_buffer_buffer'
);

use FFI::Platypus::Buffer;
use FFI::Platypus::Memory;


=attr data

An C<opaque> pointer to the buffer.

=cut

=attr length

Length of the buffer as a C<size_t>.

=cut

=attr data_deallocator

A C<CodeRef> for the deallocator.

=cut

FFI::C->struct( 'TF_Buffer' => [
	data => 'opaque',
	length => 'size_t',
	_data_deallocator => 'opaque', # data_deallocator_t
	# this does not work?
	#_data_deallocator => 'data_deallocator_t',
]);
use Sub::Delete;
delete_sub 'DESTROY';

sub data_deallocator {
	my ($self, $coderef) = shift;

	return $self->{_data_deallocator_closure} unless $coderef;

	my $closure = $ffi->closure( $coderef );

	$closure->sticky;
	$self->{_data_deallocator_closure} = $closure;

	my $opaque = $ffi->cast('data_deallocator_t', 'opaque', $closure);
	$self->_data_deallocator( $opaque );
}


=construct New

=for :signature
New()

  my $buffer = Buffer->New();

  ok $buffer, 'created an empty buffer';
  is $buffer->length, 0, 'with a length of 0';

Create an empty buffer. Useful for passing as an output parameter.

=for :returns
= TFBuffer
Empty buffer.

=tf_capi TF_NewBuffer

=cut
$ffi->attach( [ 'NewBuffer' => 'New' ] => [] => 'TF_Buffer' );

=construct NewFromString

=for :signature
NewFromString( $proto )

Makes a copy of the input and sets an appropriate deallocator. Useful for
passing in read-only, input protobufs.

  my $data = 'bytes';
  my $buffer = Buffer->NewFromString(\$data);
  ok $buffer, 'create buffer from string';
  is $buffer->length, bytes::length($data), 'same length as string';

=for :param
= ScalarRef[Bytes] $proto

=for :returns
= TFBuffer
Contains a copy of the input data from C<$proto>.

=tf_capi TF_NewBufferFromString

=cut
$ffi->attach( [ 'NewBufferFromString' => 'NewFromString' ] => [
	arg 'tf_buffer_buffer' => [qw(proto proto_len)]
] => 'TF_Buffer' => sub {
	my ($xs, $class, @rest) = @_;
	$xs->(@rest);
});

=destruct DESTROY

=tf_capi TF_DeleteBuffer

=cut

$ffi->attach( [ 'DeleteBuffer' => 'DESTROY' ] => [ 'TF_Buffer' ], 'void' );

1;
__END__

=head1 SYNOPSIS

  use aliased 'AI::TensorFlow::Libtensorflow::Buffer' => 'Buffer';

=head1 DESCRIPTION

C<TFBuffer> is a data structure that stores a pointer to a block of data, the
length of the data, and optionally a deallocator function for memory
management.

This structure is typically used in C<libtensorflow> to store the data for a
serialized protocol buffer.

=cut
