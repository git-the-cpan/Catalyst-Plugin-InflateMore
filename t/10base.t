#!/usr/bin/perl

# @(#)$Id: 10base.t 40 2009-02-22 02:49:21Z pjf $

use strict;
use warnings;
use English qw(-no_match_vars);
use FindBin qw($Bin);
use lib qq($Bin/../lib);
use Test::More;

use version; our $VERSION = qv( sprintf '0.1.%d', q$Rev: 40 $ =~ /\d+/gmx );

BEGIN {
   if ($ENV{AUTOMATED_TESTING} || $ENV{PERL_CR_SMOKER_CURRENT}
       || ($ENV{PERL5OPT} || q()) =~ m{ CPAN-Reporter }mx
       || ($ENV{PERL5_CPANPLUS_IS_RUNNING} && $ENV{PERL5_CPAN_IS_RUNNING})) {
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
