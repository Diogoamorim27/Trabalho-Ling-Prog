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

sub delete_feed
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

		print Dumper (keys(%feeds_in_file));
		print "\n ------------ \n";
		delete %feeds_in_file{$feed_name};
	
		print Dumper (keys(%feeds_in_file));

		open (my $fh, '>', $episodes_json_path)
			or die "Can't open < $episodes_json_path: $! \n ";

		my $new_file_content = to_json \%feeds_in_file, {pretty => 1};

		print $fh $new_file_content;

		close($fh)
			|| warn "$episodes_json_path - close failed: $!\n";

		#

	}
}

1;
