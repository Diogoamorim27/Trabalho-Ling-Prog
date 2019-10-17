use strict;
use warnings;
use Text::Unaccent::PurePerl qw(unac_string);
use JSON;
use File::Slurper;
use Data::Dumper; #debugging
use Unicode::Normalize

require "./perl/get_downloaded_episodes.pl";

my $episodes = get_downloaded_episodes_from_feed("waypoint", "episodes_broken.json");

print Dumper($episodes);