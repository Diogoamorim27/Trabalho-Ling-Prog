use strict;
use warnings;
use Text::Unaccent::PurePerl qw(unac_string);
use JSON;
use File::Slurper;
use Data::Dumper; #debugging
use Encode qw( encode_utf8 );
use utf8;
use open qw(:std :encoding(UTF-8));

require "./perl/delete_episode.pl";

my $episodes = delete_episode("decrepitos","Decrepitos 231 - Respondendo Testes da Capricho 5", "episodes_broken.json");

#print Dumper(%{$episodes});