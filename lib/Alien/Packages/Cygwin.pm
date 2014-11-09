package Alien::Packages::Cygwin;

use strict;
use warnings;
use IPC::Cmd qw( can_run );
use IPC::Run qw( run );

# ABSTRACT: Get information from Cygwin's packages via cygcheck
our $VERSION = '0.03'; # VERSION


if(eval { require Alien::Packages::Base; 1 })
{
  our @ISA = qw( Alien::Packages::Base );
}

my $cygcheck;


sub usable
{
  unless(defined $cygcheck)
  {
    $cygcheck = can_run 'cygcheck';
  }
  
  $cygcheck;
}


sub list_packages
{
  my @packages;

  __PACKAGE__->usable;
  
  foreach my $line (`$cygcheck -c -d`)
  {
    next if $line =~ /^(Cygwin Package Information|Package\s+Version)/;
    chomp $line;
    my($package,$version) = split /\s+/, $line;
    push @packages, {
      Package     => $package,
      Version     => $version,
      Description => '',
    };
  }
  
  @packages;
}


sub list_fileowners
{
  my($self, @files) = @_;
  my %owners;

  __PACKAGE__->usable;

  foreach my $file (@files)
  {
    my $in;
    my $out;
    my $err;
    run [$cygcheck, -f => $file], \$in, \$out, \$err;
    if($out =~ s/-[^-]*-[^-]*\s+//)
    {
      push @{ $owners{$file} }, { Package => $out };
    }
  }  
  
  %owners;
}

1;

__END__

=pod

=encoding UTF-8

=head1 NAME

Alien::Packages::Cygwin - Get information from Cygwin's packages via cygcheck

=head1 VERSION

version 0.03

=head1 SYNOPSIS

 # without Alien::Packages
 use Alien::Packages::Cygwin;
 
 foreach my $package (Alien::Packages::Cygwin->list_packages)
 {
   say 'Name:    ' . $package->{Name};
   say 'Version: ' . $package->{Version};
 }

 my $perl_package = Alien::Packages::Cygwin->list_owners('/usr/bin/perl');
 say 'Perl package is ' . $perl_package->{"/usr/bin/perl"}->[0]->{Package};

 # with Alien::Packages
 use Alien::Packages;
 
 my $packages = Alien::Packages->new;
 foreach my $package ($packages->list_packages)
 {
   say 'Name:    ' . $package->{Name};
   say 'Version: ' . $package->{Version};
 }

 my $perl_package = $packages->list_owners('/usr/bin/perl');
 say 'Perl package is ' . $perl_package->{"/usr/bin/perl"}->[0]->{Package};

=head1 DESCRIPTION

This module provides package information for the Cygwin environment.
It can also be used as a plugin for L<Alien::Packages>, and will be
used automatically if the environment is detected.

=head1 METHODS

=head2 usable

 my $usable = Alien::Packages::Cygwin->usable

Returns true when when cygcheck command was found in the path.

=head2 list_packages

 my @packages = Alien::Packages::Cygwin->list_packages

Returns the list of installed I<cygwin> packages.  Each package
is returned as a hashref containing a

=over 4

=item Package

the name of the package

=item Version

The version of the package

=item Description

Empty string (descriptions are not available).

=back

=head2 list_fileowners

 my %owners = Alien::Packages::Cygwin->list_fileowners

Returns the I<cygwin> packages that are associated with the requested files.

=head1 AUTHOR

Graham Ollis <plicease@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2013 by Graham Ollis.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
