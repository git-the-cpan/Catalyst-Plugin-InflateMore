package Catalyst::Plugin::InflateMore;

# @(#)$Id: InflateMore.pm 11 2008-05-23 20:46:59Z pjf $

use strict;
use warnings;
use base qw(Class::Data::Accessor);
use Catalyst::Utils;
use Class::C3;
use Data::Visitor::Callback;
use Path::Class;

use version; our $VERSION = qv( sprintf '0.1.%d', q$Rev: 11 $ =~ /\d+/gmx );

__PACKAGE__->mk_classaccessors( qw(_inflation_class) );

sub setup {
   my ($app, @rest) = @_;

   if (my $class = $app->config->{ 'Plugin::InflateMore' }) {
      delete $app->config->{ 'Plugin::InflateMore' };
      Catalyst::Utils::ensure_class_loaded( $class );
      $app->_inflation_class( $class->new( $app ) );
   }

   return $app->next::method( @rest );

}

sub finalize_config {
   my $app = shift;
   my $v   = Data::Visitor::Callback->new(
      plain_value => sub {
         return unless defined $_;
         s{ __(.+?)\((.+?)\)__ }{$app->_inflate( $1, $2  )}egmx;
         s{ __(.+?)__          }{$app->_inflate( $1, q() )}egmx;
      });

   $v->visit( $app->config );
   return;
}

# Private method

sub _inflate {
   my ($app, $attr, @rest) = @_;

   $attr = lc $attr;

   return $app->path_to( $rest[0] ) if ($attr eq q(home));

   my @parts = ( $app->_inflation_class->$attr(), split m{ / }mx, $rest[0] );
   my $path  = Path::Class::Dir->new(  @parts );
      $path  = Path::Class::File->new( @parts ) unless (-d $path);

   return $path->cleanup;
}

1;

__END__

=pod

=head1 Name

Catalyst::Plugin::InflateMore - Inflates symbols in application config

=head1 Version

0.1.$Revision: 11 $

=head1 Synopsis

   use Catalyst qw(InflateMore ConfigLoader ...);

=head1 Description

If symbols like __MYSYMBOL__, __BINSDIR__, or __binsdir()__ are
present in the application config they will be inflated to the
appropriate directory paths if the coresponding lower case method name
is defined in the inflation class

=head1 Configuration and Environment

The B<Plugin::InflateMore> attribute in the application config hash
contains the name of the class whoose methods will do the actual
inflating

=head1 Subroutines/Methods

=head2 setup

Create an instance of the class that will do the inflating

=head2 finalize_config

Override C::P::ConfigLoader method. Inflates any symbols matching the
patters __SYMBOL__ and __symbol( value )__

=head2 _inflate

Call the appropriate method to get the base path and append any
arguments. Returns a Path::Class object representing the arguments
passed

=head1 Diagnostics

None

=head1 Dependencies

=over 3

=item L<Catalyst::Utils>

=item L<Class::C3>

=item L<Class::Data::Accessor>

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

=head1 License and Copyright

Copyright (c) 2008 Peter Flanigan. All rights reserved

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
