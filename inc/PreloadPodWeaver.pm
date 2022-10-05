package PreloadPodWeaver;

use Moose;
extends 'Dist::Zilla::Plugin';

sub register_component {
	require Pod::Elemental::Transformer::TF_CAPI;
}

__PACKAGE__->meta->make_immutable;
no Moose;

1;
