use strict;
use warnings;
use Text::Unaccent::PurePerl qw(unac_string);
use JSON;
use File::Slurper;
use utf8;
use open qw(:std :encoding(UTF-8));

require "./perl/add_episode.pl";
#require "./perl/normalize_string.pl";

my %episode_data = (
    "title" => "Decrépitos 223 - Gugu Sobrenatural (Com Mundo Freak)",
    "date" => "Mon, 16 Oct 2020 17:30:00 -0300",
    "url" => "https://media.blubrry.com/decrepitos/decrepitos.com/podcast/2019/decrepitos_230_capricho_5.mp3"
);

#my $normalized_title = normalize_string("Decrépitos 225 - VACILO NEWS: Bandido, Polícia e Cachorrinhos");

add_episode_to_json("Decrépitos", \%episode_data, "episodes.json");
