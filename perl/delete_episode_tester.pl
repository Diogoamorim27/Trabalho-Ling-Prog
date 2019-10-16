use strict;
use warnings;
use Text::Unaccent::PurePerl qw(unac_string);
use JSON;
use File::Slurper;
use Data::Dumper; #debugging
use Unicode::Normalize

require "./perl/delete_episode.pl";

my $episodes = delete_episode("decrepitos","Decrepitos 231 - Respondendo Testes da Capricho 5", "episodes_broken.json");

#print Dumper(%{$episodes});