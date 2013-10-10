use strict;
use warnings;
use Test::More tests => 1;
use Alien::Packages::Cygwin;

my $usable = Alien::Packages::Cygwin->usable;

ok $usable, "usable = $usable";
