use strict;
use warnings;
use Text::Unaccent::PurePerl qw(unac_string);
use JSON;
use File::Slurper;
use Data::Dumper;

require "./perl/get_episodes.pl";
require "./perl/normalize_string.pl";

sub add_episode_to_json
{
	my $feed_name = $_[0];
	my %episode_data = %{$_[1]};   
	my $episodes_json_path = $_[2];

	print Dumper(\%episode_data{"title"});

	my $file_contents = File::Slurper::read_text($episodes_json_path);

	my %feeds_in_file;

	if ($file_contents eq ""){$file_contents = "{}"};

	eval {%feeds_in_file = %{decode_json($file_contents)}}; 

	if (!($@ eq "")) {
		return "error!";
	} else {

		my %feeds_in_file = %{decode_json($file_contents)};

		open (my $fh, '>', $episodes_json_path)
			or die "Can't open < $episodes_json_path: $! \n ";
	
		$feeds_in_file{$feed_name}{$episode_data{"title"}} = \%episode_data;

		#print Dumper(\$feeds_in_file{$feed_name}{$episode_data{"title"}});

		my $new_file_content = to_json \%feeds_in_file, {pretty => 1};

		print $fh $new_file_content;
#
		close($fh)
			|| warn "$episodes_json_path - close failed: $!\n";
	}
}

1;
