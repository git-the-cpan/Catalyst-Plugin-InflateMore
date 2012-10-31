# @(#)$Id: Build.PL 83 2012-10-18 16:18:47Z pjf $

use strict;
use warnings;
use inc::Bob; # Module::Build subclass
use version; our $VERSION = qv( sprintf '0.5.%d', q$Rev: 83 $ =~ /\d+/gmx );

Bob->new( {
   module     => q(Catalyst::Plugin::InflateMore),
   home_page  => q(http://www.roxsoft.co.uk),
   requires   => {
      'perl'                 => 5.010,
      'namespace::autoclean' => 0.05,
      'version'              => 0.74,
      'Catalyst'             => 5.90010,
      'Data::Visitor'        => 0.08,
      'Path::Class'          => 0.16, },
   configure_requires => { 'version'       => 0.74,
                           'Module::Build' => 0.38, },
   build_requires     => { 'Test::More'    => 0.74,
                           'MRO::Compat'   => 0.11, },
} )->create_build_script; # Goal!

# Local Variables:
# mode: perl
# tab-width: 3
# End:
