package AI::TensorFlow::Libtensorflow::Lib::_Alloc;
# ABSTRACT: [private] Allocation utilities

use AI::TensorFlow::Libtensorflow::Lib;
use FFI::Platypus::Memory qw(malloc free strcpy);
use FFI::Platypus::Buffer qw(buffer_to_scalar);
use Sub::Quote qw(quote_sub);

my $ffi = FFI::Platypus->new;
$ffi->lib(undef);
if( $ffi->find_symbol('aligned_alloc') ) {
	# C11 aligned_alloc()
	# NOTE: C11 aligned_alloc not available on Windows.
	# void *aligned_alloc(size_t alignment, size_t size);
	$ffi->attach( [ 'aligned_alloc' => '_aligned_alloc' ] =>
		[ 'size_t', 'size_t' ] => 'opaque' );
	*_aligned_free = *free;
} else {
	# Pure Perl _aligned_alloc()
	quote_sub '_aligned_alloc', q{
		my ($alignment, $size) = @_;

		# $alignment must fit in 8-bits
		die "\$alignment must be <= 255" if $alignment > 0xFF;

		my $requested_size = $alignment + $size;       # size_t
		my $ptr = malloc($requested_size);             # void*
		my $offset = $alignment - $ptr % $alignment;   # size_t
		my $aligned = $ptr + $offset;                  # void*

		strcpy $aligned - 1, chr($offset);

		return $aligned;
	};
	quote_sub '_aligned_free', q{
		my ($aligned) = @_;
		my $offset = ord(buffer_to_scalar($aligned - 1, 1));
		free( $aligned - $offset );
	};
}

use Const::Fast;
# See <https://github.com/tensorflow/tensorflow/issues/58112>.
const our $EIGEN_MAX_ALIGN_BYTES => do { _tf_alignment(); };

sub _tf_alignment {
	warn "TODO";
	return 64;
}

sub _tf_aligned_alloc {
	my ($class, $size) = @_;
	return _aligned_alloc($EIGEN_MAX_ALIGN_BYTES, $size);
}

sub _tf_aligned_free {
	my ($class, $ptr) = @_;
	_aligned_free($ptr);
}

1;
