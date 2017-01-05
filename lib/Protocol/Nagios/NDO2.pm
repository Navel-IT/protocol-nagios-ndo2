# Copyright (C) 2015-2017 Yoann Le Garff, Nicolas Boquet and Yann Le Bras
# protocol-nagios-ndo2 is licensed under the Apache License, Version 2.0

#-> BEGIN

#-> initialization

package Protocol::Nagios::NDO2 0.1;

use Navel::Base;

use Protocol::Nagios::NDO2::Data;

use Navel::Utils qw/
    croak
    blessed
/;

#-> methods

sub decode_hello {
    my ($class, $raw_hello) = @_;

    croak('raw_hello must be defined') unless defined $raw_hello;

    return {
        grep {
            length;
        } map {
            /^(\w+):\s(.*)/ && $1 => $2;
        } split /\n/, $raw_hello
    };
}

sub new {
    my ($class, $hello) = @_;

    croak('hello must be defined') unless defined $hello;

    my $self = $hello eq 'HASH' ? $hello : $class->decode_hello($hello);

    for (keys %{$self}) {
        croak('property ' . $_ . ' must be defined') unless defined $self->{$_};
    }

    croak('the PROTOCOL property must be defined') unless exists $self->{PROTOCOL};
    croak('unsupported protocol version') unless $self->{PROTOCOL} eq '2';

    bless $self, ref $class || $class;
}

sub decode_data {
    my ($self, $raw_data) = @_;

    croak('raw_data must be defined') unless defined $raw_data;

    my @raw_data = grep {
        length;
    } split /\n/, $raw_data;

    croak('incorrect packet') unless @raw_data > 2 && $raw_data[0] =~ /^(\d+):$/ && $raw_data[-1] eq '999';

    my $type = $1;

    my %data;

    for (my $i = 1; $i <= @raw_data - 2; $i++) {
        my ($attribute_id, $data) = split '=', $raw_data[$i];

        $data{$attribute_id} = $data;
    }

    Protocol::Nagios::NDO2::Data->new($type, \%data);
}

# sub AUTOLOAD {}

# sub DESTROY {}

1;

#-> END

__END__

=pod

=encoding utf8

=head1 NAME

Protocol::Nagios::NDO2

=head1 SYNOPSYS

This module implement a minimal parser for the NDO v2 protocol messages/data

=head1 COPYRIGHT

Copyright (C) 2015-2017 Yoann Le Garff, Nicolas Boquet and Yann Le Bras

=head1 LICENSE

protocol-nagios-ndo2 is licensed under the Apache License, Version 2.0

=cut
