package Pod::Elemental::Transformer::TF_CAPI;
# ABSTRACT: Transformer for TF_CAPI links

use Moose;
use Pod::Elemental::Transformer 0.101620;
with 'Pod::Elemental::Transformer';

use Pod::Elemental::Element::Pod5::Command;

use namespace::autoclean;

has command_name => (
  is  => 'ro',
  init_arg => undef,
  default => 'tf_capi',
);

sub transform_node {
  my ($self, $node) = @_;

  for my $i (reverse(0 .. $#{ $node->children })) {
    my $para = $node->children->[ $i ];
    next unless $self->__is_xformable($para);
    my @replacements = $self->_expand( $para );
    splice @{ $node->children }, $i, 1, @replacements;
  }
}

sub __is_xformable {
  my ($self, $para) = @_;

  return unless $para->isa('Pod::Elemental::Element::Pod5::Command')
         and $para->command eq $self->command_name;

  return 1;
}

sub _expand {
  my ($self, $parent) = @_;
  my @replacements;


  my $content = $parent->content;

  my @ids = split /,\s*/, $content;
  my $doc_name = 'AI::TensorFlow::Libtensorflow::Manual::CAPI';
  my $new_content = join ", ", map {
    die "$_ does not look like a TensorFlow identifier" unless /^TF[E]?_\w+$/;
    "L<< C<$_> | $doc_name/$_ >>"
  } @ids;

  push @replacements, Pod::Elemental::Element::Pod5::Ordinary->new(
    content => $new_content,
  );

  return @replacements;
}

1;
