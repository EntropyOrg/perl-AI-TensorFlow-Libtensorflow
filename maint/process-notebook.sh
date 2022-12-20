#!/bin/sh

## Requirements:
##
## perl, python, sponge, grep
##
## Perl deps:
##
## $ cpanm Devel::IPerl Perl::PrereqScanner::NotQuiteLite Cwd Path::Tiny
##
## Python deps:
##
## $ pip3 install jupyter

SRC="notebook/InferenceUsingTFHubMobileNetV2Model.ipynb";
DST="lib/AI/TensorFlow/Libtensorflow/Manual/InferenceUsingTFHubMobileNetV2Model.pod";
rm $DST;

if grep -C5 -P '\s+\\n' $SRC -m 2; then
	echo "Notebook $SRC has whitespace"
	exit 1
fi

### Run the notebook
jupyter nbconvert --execute --inplace $SRC


jupyter nbconvert \
	--ClearMetadataPreprocessor.enabled=True \
	--ClearMetadataPreprocessor.preserve_cell_metadata_mask='[("tags","kernelspec","language_info","scrolled")]' \
	--inplace --log-level=ERROR $SRC
# --ClearOutputPreprocessor.enabled=True

### Notice about generated file
echo "## DO NOT EDIT. Generated from $SRC using $0.\n" | sponge -a $DST

## Add code to $DST
jupyter nbconvert $SRC --to script --stdout | sponge -a $DST;

## Add
##   __END__
##
##   =pod
##
##   =encoding UTF-8
##
perl -E 'say qq|__END__=pod\n\n=encoding UTF-8\n\n|' | sponge -a $DST;

## Add POD
iperl nbconvert.iperl $SRC  | sponge -a $DST;

## Add
##   =head1 CPANFILE
##
##     requires '...';
##     requires '...';
scan-perl-prereqs-nqlite --cpanfile $DST | perl -M5';print qq|=head1 CPANFILE\n\n\n|' -plE '$_ = q|  | . $_;' | sponge -a $DST ;

## Check output (if on TTY)
if [ -t 0 ]; then
	perldoc $DST;
fi

## Check and run script in the directory of the original (e.g., to get data
## files).
perl -c $DST && perl -MCwd -MPath::Tiny -E '
	my $nb = path(shift @ARGV);
	my $script = path(shift @ARGV)->absolute;
	chdir $nb->parent;
	do $script;
	' $SRC $DST
