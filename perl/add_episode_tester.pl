use strict;
use warnings;
use Text::Unaccent::PurePerl qw(unac_string);
use JSON;
use File::Slurper;

require "./perl/add_episode.pl";
require "./perl/normalize_string.pl";

my $normalized_title = normalize_string("Decrépitos 230 - Respondendo Testes da Capricho 5");

add_episode_to_json("./decrepitos.xml", $normalized_title, "episodes.json");
