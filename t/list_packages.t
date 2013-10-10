use strict;
use warnings;
use Test::More tests => 3;
use Alien::Packages::Cygwin;

my @list = Alien::Packages::Cygwin->list_packages;

ok @list > 0, "at least one package";

# we assume at least the 'cygwin' package is installed.
my($package) = grep { $_->{Package} eq 'cygwin' } @list;

ok $package, "has cygwin package";

ok $package->{Version}, "package.Version = " . $package->{Version};

