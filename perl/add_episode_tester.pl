use strict;
use warnings;
use Text::Unaccent::PurePerl qw(unac_string);
use JSON;
use File::Slurper;
use utf8;
use open qw(:std :encoding(UTF-8));

require "./perl/add_feed.pl";
require "./perl/add_episode.pl";
#require "./perl/normalize_string.pl";

my %episode_data = (
    "title" => "Decrépitos 232 - Leiturão da Massa 2",
    "date" => "Mon, 16 Oct 2020 17:30:00 -0300",
    "url" => "https://media.blubrry.com/decrepitos/decrepitos.com/podcast/2019/decrepitos_232_leiturao02.mp3"
);

#my $normalized_title = normalize_string("Decrépitos 225 - VACILO NEWS: Bandido, Polícia e Cachorrinhos");

add_feed("https://decrepitos.com/podcast/feed.xml", "decrepitos.xml");
add_episode_to_json("Decrépitos", \%episode_data, "episodes.json");
