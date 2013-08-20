# @(#)Ident: 10test_script.t 2013-08-20 23:02 pjf ;

use strict;
use warnings;
use version; our $VERSION = qv( sprintf '0.7.%d', q$Rev: 1 $ =~ /\d+/gmx );
use File::Spec::Functions   qw( catdir updir );
use FindBin                 qw( $Bin );
use lib                 catdir( $Bin, updir, 'lib' );

use Module::Build;
use Test::More;

my $notes = {}; my $perl_ver;

BEGIN {
   my $builder = eval { Module::Build->current };
      $builder and $notes = $builder->notes;
      $perl_ver = $notes->{min_perl_version} || 5.008;
}

use Test::Requires "${perl_ver}";

{  package MyApp::Config;

   sub new {
      my ($me, $app) = @_;

      return bless { config => $app->config }, ref $me || $me;
   }

   sub appldir { return 'derived' }
}

{  package MyApp;

   use Catalyst qw( InflateMore );

   __PACKAGE__->config( appldir               => '__APPLDIR__',
                        'Plugin::InflateMore' => 'MyApp::Config' );
   __PACKAGE__->setup;
}

is( MyApp->config->{appldir}, '__APPLDIR__', 'Raw token' );

MyApp->finalize_config;

is( MyApp->config->{appldir}, 'derived', 'Derived at runtime' );

done_testing;

# Local Variables:
# mode: perl
# tab-width: 3
# End:
# vim: expandtab shiftwidth=3:
