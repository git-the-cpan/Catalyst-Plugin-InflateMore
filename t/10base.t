#!/usr/bin/perl

# @(#)$Id: 10base.t 35 2008-11-14 03:41:14Z pjf $

use strict;
use warnings;
use English qw(-no_match_vars);
use FindBin qw($Bin);
use lib qq($Bin/../lib);
use Test::More;

use version; our $VERSION = qv( sprintf '0.1.%d', q$Rev: 35 $ =~ /\d+/gmx );

BEGIN {
   if ($ENV{AUTOMATED_TESTING}
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
