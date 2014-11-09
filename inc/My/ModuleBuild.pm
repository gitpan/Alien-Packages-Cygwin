package My::ModuleBuild;

use strict;
use warnings;
use base qw( Module::Build );

sub new
{
  my($class, %args) = @_;
  if($^O ne 'cygwin')
  {
    print STDERR "this module only supported on Cygwin";
    exit;
  }
  my $self = $class->SUPER::new(%args);
  $self;
}

1;
