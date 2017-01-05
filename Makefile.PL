# Copyright (C) 2015-2017 Yoann Le Garff, Nicolas Boquet and Yann Le Bras
# protocol-nagios-ndo2 is licensed under the Apache License, Version 2.0

#-> BEGIN

#-> initialization

use strict;
use warnings;

use ExtUtils::MakeMaker;

#-> main

my $min_perl_version = '5.18.0';

WriteMakefile(
    NAME => 'Protocol::Nagios::NDO2',
    VERSION_FROM => 'lib/Protocol/Nagios/NDO2.pm',
    ABSTRACT => 'protocol-nagios-ndo2',
    AUTHOR => 'Yoann Le Garff, Nicolas Boquet and Yann Le Bras',
    LICENSE => 'apache_2_0',
    META_MERGE => {
        requires => {
            perl => $min_perl_version
        },
        resources => {
            license => 'http://www.apache.org/licenses/LICENSE-2.0.html',
            repository => 'http://github.com/Navel-IT/protocol-nagios-ndo2'
        }
    },
    MIN_PERL_VERSION => $min_perl_version,
    PREREQ_PM => {
        'Navel::Base' => 0
    },
    CONFIGURE_REQUIRES => {
        'ExtUtils::MakeMaker' => 6.64
    },
    TEST_REQUIRES => {
        'Test::More' => 0
    },
    test => {
        TESTS => 't/*.t'
    }
);

#-> END

__END__
