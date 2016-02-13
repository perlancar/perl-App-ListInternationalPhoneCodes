package App::ListIntlPhoneCodes;

# DATE
# VERSION

use 5.010001;
use strict;
use warnings;

use Perinci::Sub::Gen::AccessTable qw(gen_read_table_func);

our %SPEC;
use Exporter qw(import);
our @EXPORT_OK = qw(list_countries);

our $data;
{
    require Locale::Codes::Country_Codes;
    require Number::Phone::CountryCode;
    $data = [];
    my $id2names  = $Locale::Codes::Data{'country'}{'id2names'};
    my $id2alpha2 = $Locale::Codes::Data{'country'}{'id2code'}{'alpha-2'};
    my $id2alpha2 = $Locale::Codes::Data{'country'}{'id2code'}{'alpha-2'};

    for my $id (keys %$id2names) {
        my $alpha2 = $id2alpha2->{$id};
        my $npc = Number::Phone::CountryCode->new($alpha2);
        push @$data, [
            $alpha2,
            $id2names->{$id}[0],
            $npc ? $npc->country_code ? undef,
        ];
    }

    $data = [sort {$a->[0] cmp $b->[0]} @$data];
}

my $res = gen_read_table_func(
    name => 'list_intl_phone_codes',
    summary => 'List international phone calling codes',
    table_data => $data,
    table_spec => {
        summary => 'List of international phone calling codes',
        fields => {
            alpha2 => {
                summary => 'ISO 2-letter code',
                schema => 'str*',
                pos => 0,
                sortable => 1,
            },
            en_country_name => {
                summary => 'English country name',
                schema => 'str*',
                pos => 1,
                sortable => 1,
            },
            code => {
                summary => 'English country name',
                schema => 'int',
                pos => 2,
                sortable => 1,
            },
        },
        pk => 'alpha2',
    },
);
die "Can't generate function: $res->[0] - $res->[1]" unless $res->[0] == 200;

1;
#ABSTRACT:

=head1 SYNOPSIS

 # Use via list-intl-phone-codes CLI script


=head1 SEE ALSO

L<Locale::Codes>

=cut