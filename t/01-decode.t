# Copyright (C) 2015-2017 Yoann Le Garff, Nicolas Boquet and Yann Le Bras
# protocol-nagios-ndo2 is licensed under the Apache License, Version 2.0

#-> BEGIN

#-> initialization

use strict;
use warnings;

use Test::More;
use Test::Exception;

BEGIN {
    use_ok('Protocol::Nagios::NDO2');
}

#-> main

my $ndo2;

my $type = 212;

lives_ok {
    $ndo2 = Protocol::Nagios::NDO2->new('
PROTOCOL: 2
AGENT: NDO2MOD
AGENTVERSION: 2.1.2
STARTTIME: 1483609882
DISPOSITION: REALTIME
CONNECTION: TCPSOCKET
CONNECTTYPE: RECONNECT
INSTANCENAME: default
STARTDATADUMP
');
} 'instanciate the protocol handler';

lives_ok {
    $ndo2->decode_data($type . ':
1=a
2=b
999
');
} 'correct packet of data type ' . $type;

dies_ok {
    $ndo2->decode_data($type . ':
1=a
2=b
');
} 'packet miss end of data flag';

dies_ok {
    $ndo2->decode_data($type . ':
a=a
2=b
999');
} 'incorrect packet data)';

dies_ok {
    $ndo2->decode_data('9999:
1=a
2=b
999');
} 'unknown data type';

done_testing();

#-> END

__END__
