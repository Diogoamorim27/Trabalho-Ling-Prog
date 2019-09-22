use strict;
use warnings;
use Text::Unaccent::PurePerl qw(unac_string);
use JSON;
use File::Slurper;

require "./create_empty_json_array.pl";
require "./normalize_string.pl";

sub parse_feed
{
	my $file_path = $_[0];      #string with the path to *.xml file
	my %feed_data; #= %{$_[1]};  #reference to hash with feed data

	open (FEED, $file_path)
		or die "Cant open < $file_path \n";
	
	my $feed = "";

	while (my $reader = <FEED>)
	{
		$feed = $feed.$reader;
	}

	($feed_data{title})= $feed =~ /<title>(.*?)<\/title>/;

	($feed_data{language})= $feed =~ /<language>(.*?)<\/language>/;

	foreach my $key (keys %feed_data)
	{
		if ($feed_data{$key} =~ /\Q<![CDATA[\E/)
		{
			($feed_data{$key}) = $feed_data{$key} =~ /\Q<![CDATA[\E(.*)\Q]]>\E/;
		}
	}

	close(FEED);

	return %feed_data;
}

sub add_feed
{
	my $url = $_[0];
	my $temp_file_path = $_[1];

	my %feed_data;

	%feed_data = parse_feed($temp_file_path, \%feed_data);
	$feed_data{url} = $url;
	my $normalized_title = normalize_string($feed_data{title});

	my $cli_command = "mkdir .feeds/".$normalized_title;
	system($cli_command); #create feed directory

	$cli_command = "mkdir .feeds/".$normalized_title."/eps";
	system($cli_command); #create downloaded episodes directory

	$cli_command = "mv ".$temp_file_path." .feeds/".$normalized_title."/".$normalized_title.".xml";
	system($cli_command); #changes temporary *.xml file to correct name and moves it to feed directory;

	return %feed_data;
}

sub append_feed
{
	my $feeds_file_path = "feeds.json";
	my $new_feed_json;
	
	my $file_contents = File::Slurper::read_text($feeds_file_path);

	open (my $fh, '>', $feeds_file_path)
		or die "Cant open < $feeds_file_path! \n ";

	my %new_feed_hash = @_;

	my @file_content_array = @{decode_json($file_contents)};

	push @file_content_array, {%new_feed_hash};

	my $new_file_content = to_json \@file_content_array, {pretty => 1} ;

	print $fh $new_file_content;

		
}

#programa de teste
#
#
create_empty_json_array("./feeds.json");
my %new_feed = parse_feed("./waypoint_radio.xml");
append_feed(%new_feed);
%new_feed = parse_feed("./decrepitos.xml");
append_feed(%new_feed);
