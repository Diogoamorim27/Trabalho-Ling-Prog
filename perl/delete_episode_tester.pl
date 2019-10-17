use strict;
use warnings;
use JSON;
use File::Slurper;
use Data::Dumper; #debugging
use Encode qw( encode_utf8 );
use utf8;
use open qw(:std :encoding(UTF-8));

require "./perl/delete_episode.pl";

my $episodes = delete_episode("Decrépitos","Decrépitos 100 - teste", "episodes.json");

#print Dumper(%{$episodes});
