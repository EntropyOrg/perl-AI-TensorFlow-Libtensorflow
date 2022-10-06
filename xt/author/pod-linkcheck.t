use strict;
use warnings;
use Test::More 0.88;
use Test::Pod::LinkCheck::Lite;

my $t = Test::Pod::LinkCheck::Lite->new();
$t->all_pod_files_ok();

done_testing;
