use strict;
use warnings;
use JSON;
use File::Slurper;
use Data::Dumper; #debugging
use utf8;
use open qw(:std :encoding(UTF-8));

require "./perl/get_downloaded_episodes.pl";

my @episodes = @{get_downloaded_episodes_from_feed("Decrépitos", "episodes.json")};

print "$episodes[0]{date}\n";
#print Dumper($episodes);
