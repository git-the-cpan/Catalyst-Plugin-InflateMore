# @(#)$Id: 01always_pass.t 83 2012-10-18 16:18:47Z pjf $

use strict;
use warnings;

use Sys::Hostname; my $host = lc hostname; warn "Hostname: ${host}\n";

print "1..1\n";
print "ok\n";
exit 0;

# Local Variables:
# mode: perl
# tab-width: 3
# End:
