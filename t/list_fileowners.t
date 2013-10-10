use strict;
use warnings;
use Test::More tests => 2;
use Alien::Packages::Cygwin;

my %owners = Alien::Packages::Cygwin->list_fileowners(
  Alien::Packages::Cygwin->usable
);

ok %owners, 'at least one owner for ' . Alien::Packages::Cygwin->usable;

is $owners{Alien::Packages::Cygwin->usable}->[0]->{Package}, 'cygwin', 'owners{' . Alien::Packages::Cygwin->usable . '} = cygwin';
