use strict;
use warnings;
use Text::Unaccent::PurePerl qw(unac_string);
use JSON;
use File::Slurper;
use Data::Dumper; #debugging
use Encode qw( encode_utf8 );
use utf8;
use open qw(:std :encoding(UTF-8));

require "./perl/delete_feed.pl";

delete_feed ("decrepitos", "episodes_broken.json");

#print Dumper(%{$episodes});