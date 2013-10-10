use strict;
use warnings;
use Test::More;
BEGIN { plan skip_all => 'requires Alien::Packages' unless eval q{ require Alien::Packages; 1 } }
plan tests => 3;

my $packages = Alien::Packages->new;
isa_ok $packages, 'Alien::Packages';

subtest 'list_packages' => sub {
  plan tests => 3;

  my @list = $packages->list_packages;

  ok @list > 0, "at least one package";

  # we assume at least the 'cygwin' package is installed.
  my($package) = grep { $_->{Package} eq 'cygwin' } @list;

  ok $package, "has cygwin package";

  ok $package->{Version}, "package.Version = " . $package->{Version};

};

subtest 'list_fileowners' => sub {

  plan tests => 2;

  my %owners = $packages->list_fileowners(
    Alien::Packages::Cygwin->usable
  );

  ok %owners, 'at least one owner for ' . Alien::Packages::Cygwin->usable;

  is $owners{Alien::Packages::Cygwin->usable}->[0]->{Package}, 'cygwin', 'owners{' . Alien::Packages::Cygwin->usable . '} = cygwin';

};
