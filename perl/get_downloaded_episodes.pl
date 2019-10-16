use strict;
use warnings;
use Text::Unaccent::PurePerl qw(unac_string);
use JSON;
use File::Slurper;
use Data::Dumper; #debugging
use Encode qw( encode_utf8 );
use utf8;
use open qw(:std :encoding(UTF-8));

require "./perl/get_episodes.pl";
require "./perl/normalize_string.pl";

sub get_downloaded_episodes_from_feed
{
	my $feed_name = $_[0];
	my $episodes_json_path = $_[1];

	#print Dumper(\%episode_data{"title"});

	my $file_contents = File::Slurper::read_text($episodes_json_path);

	$file_contents = unac_string("UTF-8", encode_utf8($file_contents));

	my %feeds_in_file;

	if ($file_contents eq ""){return ""};

	eval {%feeds_in_file = %{decode_json($file_contents)}}; 

	if (!($@ eq "")) {
		return $@;
	} else {

		my %feeds_in_file = %{decode_json($file_contents)};

		my %episodes = %feeds_in_file{$feed_name};
		my @episodes_vector = values(%episodes);
		return $episodes_vector[0];
	}
}

1;
