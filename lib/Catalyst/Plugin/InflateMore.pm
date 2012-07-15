# @(#)$Id: InflateMore.pm 81 2012-07-15 00:24:12Z pjf $

package Catalyst::Plugin::InflateMore;

use strict;
use warnings;
use namespace::autoclean;
use version; our $VERSION = qv( sprintf '0.4.%d', q$Rev: 81 $ =~ /\d+/gmx );

use Catalyst::Utils;
use Data::Visitor::Callback;
use Path::Class ();

my $KEY = q(Plugin::InflateMore);
my $SEP = q(/);

sub setup {
   my ($self, @rest) = @_;

   $self->mk_classdata( q(_inflator) );

   if (my $class = $self->config->{ $KEY }) {
      Catalyst::Utils::ensure_class_loaded( $class );
      $self->_inflator( $class->new( $self ) );
   }

   return $self->next::method( @rest );
}

sub finalize_config {
   my $self = shift;
   my $v    = Data::Visitor::Callback->new(
      plain_value => sub {
         return unless defined $_;
         s{ __(.+?)\((.+?)\)__ }{$self->_inflate_symbols( $1, $2  )}egmx;
         s{ __(.+?)__          }{$self->_inflate_symbols( $1, q() )}egmx;
      } );

   $v->visit( $self->config );
   return;
}

# Private method

sub _inflate_symbols {
   my ($self, $attr, @rest) = @_; $attr = lc $attr;

   $attr eq q(home) and return $self->path_to( $rest[ 0 ] );

   my @parts = ($self->_inflator->$attr(), split m{ $SEP }mx, $rest[ 0 ]);
   my $path  = Path::Class::Dir->new( @parts );

   -d $path or $path = Path::Class::File->new( @parts );

   return $path->cleanup;
}

1;

__END__

=pod

=head1 Name

Catalyst::Plugin::InflateMore - Inflates symbols in application config

=head1 Version

0.4.$Revision: 81 $

=head1 Synopsis

   package YourApp;

   use Catalyst qw(InflateMore ConfigLoader ...);

   # In your applications config file
   <appldir>__APPLDIR__</appldir>
   <binsdir>__BINSDIR__</binsdir>
   <libsdir>__LIBSDIR__</libsdir>
   <ctrldir>__appldir(var/etc)__</ctrldir>
   <dbasedir>__appldir(var/db)__</dbasedir>
   <logfile>__appldir(var/logs/server.log)__</logfile>
   <logsdir>__appldir(var/logs)__</logsdir>
   <root>__appldir(var/root)__</root>
   <rprtdir>__appldir(var/root/reports)__</rprtdir>
   <rundir>__appldir(var/run)__</rundir>
   <skindir>__appldir(var/root/skins)__</skindir>
   <tempdir>__appldir(var/tmp)__</tempdir>
   <vardir>__appldir(var)__</vardir>

=head1 Description

If symbols like I<__MYSYMBOL__>, I<__BINSDIR__>, or I<__binsdir()__>
are present in the application config they will be inflated to the
appropriate directory paths if the coresponding lower case method name
is defined in the inflation class

=head1 Configuration and Environment

The I<Plugin::InflateMore> attribute in the application config hash
contains the name of the class whoose methods will do the actual
inflating

Symbols should always use the forward slash as a path separator regardless
of OS type, i.e. I<__appldir(var/logs)__>

=head1 Subroutines/Methods

=head2 setup

Create an instance of the class that will do the inflating

=head2 finalize_config

Override L<Catalyst::Plugin::ConfigLoader> method. Will inflate any
symbols matching the patterns I<__SYMBOL__> and I<__symbol( value )__>

=head2 _inflate_symbols

Call the appropriate method to get the base path and append any
arguments. Returns a L<Path::Class> object representing the arguments
passed

=head1 Diagnostics

None

=head1 Dependencies

=over 3

=item L<Catalyst::Utils>

=item L<Data::Visitor::Callback>

=item L<Path::Class>

=back

=head1 Incompatibilities

There are no known incompatibilities in this module

=head1 Bugs and Limitations

There are no known bugs in this module.
Please report problems to the address below.
Patches are welcome

=head1 Author

Peter Flanigan,  C<< <Support at RoxSoft.co.uk> >>

=head1 Acknowledgements

Larry Wall - For the Perl programming language

=head1 License and Copyright

Copyright (c) 2008-2012 Peter Flanigan. All rights reserved

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself. See L<perlartistic>

This program is distributed in the hope that it will be useful,
but WITHOUT WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE

=cut

# Local Variables:
# mode: perl
# tab-width: 3
# End:

