# @(#)$Id: CPANTesting.pm 83 2012-10-18 16:18:47Z pjf $

package CPANTesting;

use strict;
use warnings;

use Sys::Hostname; my $host = lc hostname; my $osname = lc $^O;

sub should_abort {
   return 0;
}

sub test_exceptions {
   my $p = shift; __is_testing() or return 0;

   $p->{stop_tests} and return 'CPAN Testing stopped in Build.PL';

   $osname eq q(cygwin)  and return 'Cygwin  OS unsupported';
   $osname eq q(mirbsd)  and return 'Mirbsd  OS unsupported';
   $osname eq q(mswin32) and return 'MSWin32 OS unsupported';
   return 0;
}

# Private functions
# Is this an attempted install on a CPAN testing platform?
sub __is_testing { !! ($ENV{AUTOMATED_TESTING} || $ENV{PERL_CR_SMOKER_CURRENT}
                   || ($ENV{PERL5OPT} || q()) =~ m{ CPAN-Reporter }mx) }

1;

__END__