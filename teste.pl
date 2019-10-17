use strict;
use warnings;
use JSON;
use File::Slurper;
use Data::Dumper; #debugging
use utf8;
use open qw(:std :encoding(UTF-8));
use Encode qw( encode_utf8 );
use Text::Unaccent::PurePerl;

use podcastUtils;

my %episode_data = (
    "title" => "Decrépitos 232 - Leiturão da Massa 2",
    "date" => "Mon, 16 Oct 2020 17:30:00 -0300",
    "url" => "https://media.blubrry.com/decrepitos/decrepitos.com/podcast/2019/decrepitos_232_leiturao02.mp3"
);

add_feed("https://decrepitos.com/podcast/feed.xml", "decrepitos.xml");
add_episode_to_json("Decrépitos", \%episode_data, "episodes.json");



