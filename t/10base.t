# @(#)$Id: 10base.t 52 2009-06-12 12:00:20Z pjf $

use strict;
use warnings;
use version; our $VERSION = qv( sprintf '0.2.%d', q$Rev: 52 $ =~ /\d+/gmx );
use File::Spec::Functions;
use FindBin qw( $Bin );
use lib catdir( $Bin, updir, q(lib) );

use English qw( -no_match_vars );
use Test::More;

BEGIN {
   if ($ENV{AUTOMATED_TESTING} || $ENV{PERL_CR_SMOKER_CURRENT}
       || ($ENV{PERL5OPT} || q()) =~ m{ CPAN-Reporter }mx) {
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
