use strict;
use warnings;
use Text::Unaccent::PurePerl qw(unac_string);
use JSON;
use File::Slurper;

require "./perl/add_episode.pl";
require "./perl/normalize_string.pl";

my %episode_data = (
    "title" => "Decrépitos 233 - Respondendo Testes da Capricho 5",
    "date" => "Mon, 16 Sep 2019 17:30:00 -0300",
    "url" => "https://media.blubrry.com/decrepitos/decrepitos.com/podcast/2019/decrepitos_230_capricho_5.mp3"
);

my $normalized_title = normalize_string("Decrépitos 225 - VACILO NEWS: Bandido, Polícia e Cachorrinhos");

print add_episode_to_json("waypoint", \%episode_data, "episodes_broken.json");
