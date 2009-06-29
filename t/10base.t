# @(#)$Id: 10base.t 65 2009-06-29 16:44:58Z pjf $

use strict;
use warnings;
use version; our $VERSION = qv( sprintf '0.2.%d', q$Rev: 65 $ =~ /\d+/gmx );
use File::Spec::Functions;
use FindBin qw( $Bin );
use lib catdir( $Bin, updir, q(lib) );

use English qw( -no_match_vars );
use Test::More;

BEGIN {
   if ($ENV{AUTOMATED_TESTING}  || $ENV{PERL_CR_SMOKER_CURRENT} ||
       $ENV{PERL5_MINISMOKEBOX} || $ENV{PERL5_YACSMOKE_BASE}) {
      plan skip_all => q(CPAN Testing stopped);
   }

   plan tests => 2;
}

{
   package MyApp::Config;

   sub new {
      my ($me, $app) = @_;

      return bless { config => $app->config }, ref $me || $me;
   }

   sub appldir { return q(derived) }
}

{
    package MyApp;

    use Catalyst qw(InflateMore);

    __PACKAGE__->config( appldir               => '__APPLDIR__',
                         'Plugin::InflateMore' => 'MyApp::Config' );
    __PACKAGE__->setup;
}

ok( MyApp->config->{appldir} eq q(__APPLDIR__), q(Raw token) );

MyApp->finalize_config;

ok( MyApp->config->{appldir} eq q(derived), q(Derived at runtime) );

# Local Variables:
# mode: perl
# tab-width: 3
# End:
