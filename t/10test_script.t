# @(#)Ident: 10test_script.t 2013-08-11 12:52 pjf ;

use strict;
use warnings;
use version; our $VERSION = qv( sprintf '0.6.%d', q$Rev: 1 $ =~ /\d+/gmx );
use File::Spec::Functions   qw( catdir updir );
use FindBin                 qw( $Bin );
use lib                 catdir( $Bin, updir, 'lib' );

use Test::More;

{  package MyApp::Config;

   sub new {
      my ($me, $app) = @_;

      return bless { config => $app->config }, ref $me || $me;
   }

   sub appldir { return q(derived) }
}

{  package MyApp;

   use Catalyst qw(InflateMore);

   __PACKAGE__->config( appldir               => '__APPLDIR__',
                        'Plugin::InflateMore' => 'MyApp::Config' );
   __PACKAGE__->setup;
}

is( MyApp->config->{appldir}, q(__APPLDIR__), 'Raw token' );

MyApp->finalize_config;

is( MyApp->config->{appldir}, q(derived), 'Derived at runtime' );

done_testing;

# Local Variables:
# mode: perl
# tab-width: 3
# End:
