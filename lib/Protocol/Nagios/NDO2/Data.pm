# Copyright (C) 2015-2017 Yoann Le Garff, Nicolas Boquet and Yann Le Bras
# protocol-nagios-ndo2 is licensed under the Apache License, Version 2.0

#-> BEGIN

#-> initialization

package Protocol::Nagios::NDO2::Data 0.1;

use Navel::Base;

use Navel::Utils 'croak';

#-> class variables

my %types = (
    100 => 'LOGENTRY',
    200 => 'PROCESSDATA',
    201 => 'TIMEDEVENTDATA',
    202 => 'LOGDATA',
    203 => 'SYSTEMCOMMANDDATA',
    204 => 'EVENTHANDLERDATA',
    205 => 'NOTIFICATIONDATA',
    206 => 'SERVICECHECKDATA',
    207 => 'HOSTCHECKDATA',
    208 => 'COMMENTDATA',
    209 => 'DOWNTIMEDATA',
    210 => 'FLAPPINGDATA',
    211 => 'PROGRAMSTATUSDATA',
    212 => 'HOSTSTATUSDATA',
    213 => 'SERVICESTATUSDATA',
    214 => 'ADAPTIVEPROGRAMDATA',
    215 => 'ADAPTIVEHOSTDATA',
    216 => 'ADAPTIVESERVICEDATA',
    217 => 'EXTERNALCOMMANDDATA',
    218 => 'AGGREGATEDSTATUSDATA',
    219 => 'RETENTIONDATA',
    220 => 'CONTACTNOTIFICATIONDATA',
    221 => 'CONTACTNOTIFICATIONMETHODDATA',
    222 => 'ACKNOWLEDGEMENTDATA',
    223 => 'STATECHANGEDATA',
    224 => 'CONTACTSTATUSDATA',
    225 => 'ADAPTIVECONTACTDATA',
    300 => 'MAINCONFIGFILEVARIABLES',
    301 => 'RESOURCECONFIGFILEVARIABLES',
    302 => 'CONFIGVARIABLES',
    303 => 'RUNTIMEVARIABLES',
    400 => 'HOSTDEFINITION',
    401 => 'HOSTGROUPDEFINITION',
    402 => 'SERVICEDEFINITION',
    403 => 'SERVICEGROUPDEFINITION',
    404 => 'HOSTDEPENDENCYDEFINITION',
    405 => 'SERVICEDEPENDENCYDEFINITION',
    406 => 'HOSTESCALATIONDEFINITION',
    407 => 'SERVICEESCALATIONDEFINITION',
    408 => 'COMMANDDEFINITION',
    409 => 'TIMEPERIODDEFINITION',
    410 => 'CONTACTDEFINITION',
    411 => 'CONTACTGROUPDEFINITION',
    412 => 'HOSTEXTINFODEFINITION',
    413 => 'SERVICEEXTINFODEFINITION',
    414 => 'ACTIVEOBJECTSLIST'
);

my %attributes = (
    0 => 'NONE',
    1 => 'TYPE',
    2 => 'FLAGS',
    3 => 'ATTRIBUTES',
    4 => 'TIMESTAMP',
    5 => 'ACKAUTHOR',
    6 => 'ACKDATA',
    7 => 'ACKNOWLEDGEMENTTYPE',
    8 => 'ACTIVEHOSTCHECKSENABLED',
    9 => 'ACTIVESERVICECHECKSENABLED',
    10 => 'AUTHORNAME',
    11 => 'CHECKCOMMAND',
    12 => 'CHECKTYPE',
    13 => 'COMMANDARGS',
    14 => 'COMMANDLINE',
    15 => 'COMMANDSTRING',
    16 => 'COMMANDTYPE',
    17 => 'COMMENT',
    18 => 'COMMENTID',
    19 => 'COMMENTTIME',
    20 => 'COMMENTTYPE',
    21 => 'CONFIGFILENAME',
    22 => 'CONFIGFILEVARIABLE',
    23 => 'CONFIGVARIABLE',
    24 => 'CONTACTSNOTIFIED',
    25 => 'CURRENTCHECKATTEMPT',
    26 => 'CURRENTNOTIFICATIONNUMBER',
    27 => 'CURRENTSTATE',
    28 => 'DAEMONMODE',
    29 => 'DOWNTIMEID',
    30 => 'DOWNTIMETYPE',
    31 => 'DURATION',
    32 => 'EARLYTIMEOUT',
    33 => 'ENDTIME',
    34 => 'ENTRYTIME',
    35 => 'ENTRYTYPE',
    36 => 'ESCALATED',
    37 => 'EVENTHANDLER',
    38 => 'EVENTHANDLERENABLED',
    39 => 'EVENTHANDLERSENABLED',
    40 => 'EVENTHANDLERTYPE',
    41 => 'EVENTTYPE',
    42 => 'EXECUTIONTIME',
    43 => 'EXPIRATIONTIME',
    44 => 'EXPIRES',
    45 => 'FAILUREPREDICTIONENABLED',
    46 => 'FIXED',
    47 => 'FLAPDETECTIONENABLED',
    48 => 'FLAPPINGTYPE',
    49 => 'GLOBALHOSTEVENTHANDLER',
    50 => 'GLOBALSERVICEEVENTHANDLER',
    51 => 'HASBEENCHECKED',
    52 => 'HIGHTHRESHOLD',
    53 => 'HOST',
    54 => 'ISFLAPPING',
    55 => 'LASTCOMMANDCHECK',
    56 => 'LASTHARDSTATE',
    57 => 'LASTHARDSTATECHANGE',
    58 => 'LASTHOSTCHECK',
    59 => 'LASTHOSTNOTIFICATION',
    60 => 'LASTLOGROTATION',
    61 => 'LASTSERVICECHECK',
    62 => 'LASTSERVICENOTIFICATION',
    63 => 'LASTSTATECHANGE',
    64 => 'LASTTIMECRITICAL',
    65 => 'LASTTIMEDOWN',
    66 => 'LASTTIMEOK',
    67 => 'LASTTIMEUNKNOWN',
    68 => 'LASTTIMEUNREACHABLE',
    69 => 'LASTTIMEUP',
    70 => 'LASTTIMEWARNING',
    71 => 'LATENCY',
    72 => 'LOGENTRY',
    73 => 'LOGENTRYTIME',
    74 => 'LOGENTRYTYPE',
    75 => 'LOWTHRESHOLD',
    76 => 'MAXCHECKATTEMPTS',
    77 => 'MODIFIEDHOSTATTRIBUTE',
    78 => 'MODIFIEDHOSTATTRIBUTES',
    79 => 'MODIFIEDSERVICEATTRIBUTE',
    80 => 'MODIFIEDSERVICEATTRIBUTES',
    81 => 'NEXTHOSTCHECK',
    82 => 'NEXTHOSTNOTIFICATION',
    83 => 'NEXTSERVICECHECK',
    84 => 'NEXTSERVICENOTIFICATION',
    85 => 'NOMORENOTIFICATIONS',
    86 => 'NORMALCHECKINTERVAL',
    87 => 'NOTIFICATIONREASON',
    88 => 'NOTIFICATIONSENABLED',
    89 => 'NOTIFICATIONTYPE',
    90 => 'NOTIFYCONTACTS',
    91 => 'OBSESSOVERHOST',
    92 => 'OBSESSOVERHOSTS',
    93 => 'OBSESSOVERSERVICE',
    94 => 'OBSESSOVERSERVICES',
    95 => 'OUTPUT',
    96 => 'PASSIVEHOSTCHECKSENABLED',
    97 => 'PASSIVESERVICECHECKSENABLED',
    98 => 'PERCENTSTATECHANGE',
    99 => 'PERFDATA',
    100 => 'PERSISTENT',
    101 => 'PROBLEMHASBEENACKNOWLEDGED',
    102 => 'PROCESSID',
    103 => 'PROCESSPERFORMANCEDATA',
    104 => 'PROGRAMDATE',
    105 => 'PROGRAMNAME',
    106 => 'PROGRAMSTARTTIME',
    107 => 'PROGRAMVERSION',
    108 => 'RECURRING',
    109 => 'RETRYCHECKINTERVAL',
    110 => 'RETURNCODE',
    111 => 'RUNTIME',
    112 => 'RUNTIMEVARIABLE',
    113 => 'SCHEDULEDDOWNTIMEDEPTH',
    114 => 'SERVICE',
    115 => 'SHOULDBESCHEDULED',
    116 => 'SOURCE',
    117 => 'STARTTIME',
    118 => 'STATE',
    119 => 'STATECHANGE',
    120 => 'STATECHANGETYPE',
    121 => 'STATETYPE',
    122 => 'STICKY',
    123 => 'TIMEOUT',
    124 => 'TRIGGEREDBY',
    125 => 'LONGOUTPUT',
    126 => 'ACTIONURL',
    127 => 'COMMANDNAME',
    128 => 'CONTACTADDRESS',
    129 => 'CONTACTALIAS',
    130 => 'CONTACTGROUP',
    131 => 'CONTACTGROUPALIAS',
    132 => 'CONTACTGROUPMEMBER',
    133 => 'CONTACTGROUPNAME',
    134 => 'CONTACTNAME',
    135 => 'DEPENDENCYTYPE',
    136 => 'DEPENDENTHOSTNAME',
    137 => 'DEPENDENTSERVICEDESCRIPTION',
    138 => 'EMAILADDRESS',
    139 => 'ESCALATEONCRITICAL',
    140 => 'ESCALATEONDO2WN',
    141 => 'ESCALATEONRECOVERY',
    142 => 'ESCALATEONUNKNOWN',
    143 => 'ESCALATEONUNREACHABLE',
    144 => 'ESCALATEONWARNING',
    145 => 'ESCALATIONPERIOD',
    146 => 'FAILONCRITICAL',
    147 => 'FAILONDO2WN',
    148 => 'FAILONOK',
    149 => 'FAILONUNKNOWN',
    150 => 'FAILONUNREACHABLE',
    151 => 'FAILONUP',
    152 => 'FAILONWARNING',
    153 => 'FIRSTNOTIFICATION',
    154 => 'HAVE2DCOORDS',
    155 => 'HAVE3DCOORDS',
    156 => 'HIGHHOSTFLAPTHRESHOLD',
    157 => 'HIGHSERVICEFLAPTHRESHOLD',
    158 => 'HOSTADDRESS',
    159 => 'HOSTALIAS',
    160 => 'HOSTCHECKCOMMAND',
    161 => 'HOSTCHECKINTERVAL',
    162 => 'HOSTCHECKPERIOD',
    163 => 'HOSTEVENTHANDLER',
    164 => 'HOSTEVENTHANDLERENABLED',
    165 => 'HOSTFAILUREPREDICTIONENABLED',
    166 => 'HOSTFAILUREPREDICTIONOPTIONS',
    167 => 'HOSTFLAPDETECTIONENABLED',
    168 => 'HOSTFRESHNESSCHECKSENABLED',
    169 => 'HOSTFRESHNESSTHRESHOLD',
    170 => 'HOSTGROUPALIAS',
    171 => 'HOSTGROUPMEMBER',
    172 => 'HOSTGROUPNAME',
    173 => 'HOSTMAXCHECKATTEMPTS',
    174 => 'HOSTNAME',
    175 => 'HOSTNOTIFICATIONCOMMAND',
    176 => 'HOSTNOTIFICATIONINTERVAL',
    177 => 'HOSTNOTIFICATIONPERIOD',
    178 => 'HOSTNOTIFICATIONSENABLED',
    179 => 'ICONIMAGE',
    180 => 'ICONIMAGEALT',
    181 => 'INHERITSPARENT',
    182 => 'LASTNOTIFICATION',
    183 => 'LOWHOSTFLAPTHRESHOLD',
    184 => 'LOWSERVICEFLAPTHRESHOLD',
    185 => 'MAXSERVICECHECKATTEMPTS',
    186 => 'NOTES',
    187 => 'NOTESURL',
    188 => 'NOTIFICATIONINTERVAL',
    189 => 'NOTIFYHOSTDOWN',
    190 => 'NOTIFYHOSTFLAPPING',
    191 => 'NOTIFYHOSTRECOVERY',
    192 => 'NOTIFYHOSTUNREACHABLE',
    193 => 'NOTIFYSERVICECRITICAL',
    194 => 'NOTIFYSERVICEFLAPPING',
    195 => 'NOTIFYSERVICERECOVERY',
    196 => 'NOTIFYSERVICEUNKNOWN',
    197 => 'NOTIFYSERVICEWARNING',
    198 => 'PAGERADDRESS',
    199 => 'PARALLELIZESERVICECHECK',
    200 => 'PARENTHOST',
    201 => 'PROCESSHOSTPERFORMANCEDATA',
    202 => 'PROCESSSERVICEPERFORMANCEDATA',
    203 => 'RETAINHOSTNONSTATUSINFORMATION',
    204 => 'RETAINHOSTSTATUSINFORMATION',
    205 => 'RETAINSERVICENONSTATUSINFORMATION',
    206 => 'RETAINSERVICESTATUSINFORMATION',
    207 => 'SERVICECHECKCOMMAND',
    208 => 'SERVICECHECKINTERVAL',
    209 => 'SERVICECHECKPERIOD',
    210 => 'SERVICEDESCRIPTION',
    211 => 'SERVICEEVENTHANDLER',
    212 => 'SERVICEEVENTHANDLERENABLED',
    213 => 'SERVICEFAILUREPREDICTIONENABLED',
    214 => 'SERVICEFAILUREPREDICTIONOPTIONS',
    215 => 'SERVICEFLAPDETECTIONENABLED',
    216 => 'SERVICEFRESHNESSCHECKSENABLED',
    217 => 'SERVICEFRESHNESSTHRESHOLD',
    218 => 'SERVICEGROUPALIAS',
    219 => 'SERVICEGROUPMEMBER',
    220 => 'SERVICEGROUPNAME',
    221 => 'SERVICEISVOLATILE',
    222 => 'SERVICENOTIFICATIONCOMMAND',
    223 => 'SERVICENOTIFICATIONINTERVAL',
    224 => 'SERVICENOTIFICATIONPERIOD',
    225 => 'SERVICENOTIFICATIONSENABLED',
    226 => 'SERVICERETRYINTERVAL',
    227 => 'SHOULDBEDRAWN',
    228 => 'STALKHOSTONDO2WN',
    229 => 'STALKHOSTONUNREACHABLE',
    230 => 'STALKHOSTONUP',
    231 => 'STALKSERVICEONCRITICAL',
    232 => 'STALKSERVICEONOK',
    233 => 'STALKSERVICEONUNKNOWN',
    234 => 'STALKSERVICEONWARNING',
    235 => 'STATUSMAPIMAGE',
    236 => 'TIMEPERIODALIAS',
    237 => 'TIMEPERIODNAME',
    238 => 'TIMERANGE',
    239 => 'VRMLIMAGE',
    240 => 'X2D',
    241 => 'X3D',
    242 => 'Y2D',
    243 => 'Y3D',
    244 => 'Z3D',
    245 => 'CONFIGDUMPTYPE',
    246 => 'FIRSTNOTIFICATIONDELAY',
    247 => 'HOSTRETRYINTERVAL',
    248 => 'NOTIFYHOSTDOWNTIME',
    249 => 'NOTIFYSERVICEDOWNTIME',
    250 => 'CANSUBMITCOMMANDS',
    251 => 'FLAPDETECTIONONUP',
    252 => 'FLAPDETECTIONONDO2WN',
    253 => 'FLAPDETECTIONONUNREACHABLE',
    254 => 'FLAPDETECTIONONOK',
    255 => 'FLAPDETECTIONONWARNING',
    256 => 'FLAPDETECTIONONUNKNOWN',
    257 => 'FLAPDETECTIONONCRITICAL',
    258 => 'DISPLAYNAME',
    259 => 'DEPENDENCYPERIOD',
    260 => 'MODIFIEDCONTACTATTRIBUTE',
    261 => 'MODIFIEDCONTACTATTRIBUTES',
    262 => 'CUSTOMVARIABLE',
    263 => 'HASBEENMODIFIED',
    264 => 'CONTACT',
    265 => 'LASTSTATE',
    266 => 'IMPORTANCE',
    267 => 'MINIMUMIMPORTANCE',
    268 => 'PARENTSERVICE',
    269 => 'ACTIVEOBJECTSTYPE'
);

#-> methods

sub new {
    my ($class, $type, $data) = @_;

    croak('type must be defined') unless defined $type;
    croak('unknown data type') unless exists $types{$type};

    croak('data must be a HASH reference') unless ref $data eq 'HASH';

    my $self = {
        type => $types{$type},
        values => {}
    };

    for (keys %{$data}) {
        croak(($_ // '') . ': unknown type attribute') unless exists $attributes{$_};

        $self->{values}->{$attributes{$_}} = $data->{$_};
    }

    bless $self, ref $class || $class;
}

# sub AUTOLOAD {}

# sub DESTROY {}

1;

#-> END

__END__

=pod

=encoding utf8

=head1 NAME

Protocol::Nagios::NDO2::Data

=head1 COPYRIGHT

Copyright (C) 2015-2017 Yoann Le Garff, Nicolas Boquet and Yann Le Bras

=head1 LICENSE

protocol-nagios-ndo2 is licensed under the Apache License, Version 2.0

=cut
