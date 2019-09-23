use strict;
use warnings;
use Text::Unaccent::PurePerl qw(unac_string);
use JSON;
use File::Slurper;

require "./perl/get_episodes.pl";
require "./perl/add_feed.pl";
require "./perl/normalize_string.pl";

sub add_episode_to_json
{
	my $feed_xml_path = $_[0];
	my $episode_name = $_[1];   #normalized episode title
	my $episodes_json_path = $_[2];

	my $file_contents = File::Slurper::read_text($episodes_json_path);

	open (my $fh, '>', $episodes_json_path)
		or die "Can't open < $episodes_json_path: $!\n";

	my @feed_episodes = get_episodes($feed_xml_path);

	my %feeds_in_file  = %{decode_json($file_contents)};

	for my $i (0 .. $#feed_episodes)
	{
		if (!($episode_name cmp normalize_string($feed_episodes[$i]{title}))){	
			$feeds_in_file{$feed_xml_path}{$episode_name} = $feed_episodes[$i];
		};
	};

	my $new_file_content = to_json \%feeds_in_file, {pretty => 1};

	print $fh $new_file_content;

	close($fh)
		|| warn "$episodes_json_path - close failed: $!\n";
	
} 

1;
