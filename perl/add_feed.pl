use strict;
use warnings;
use Text::Unaccent::PurePerl qw(unac_string);
use JSON;
use File::Slurper;
use utf8;
use open qw(:std :encoding(UTF-8));
use Encode qw( encode_utf8 );

require "./perl/create_empty_json_array.pl";
require "./perl/normalize_string.pl";

sub parse_feed
{
	my $file_path = $_[0];      #string with the path to *.xml file
	my %feed_data;

	open (my $fh, "<", $file_path)
		or die "Can't open < $file_path: $!\n";
	
	my $feed = "";

	while (my $reader = <$fh>)
	{
		$feed = $feed.$reader;
	}

	($feed_data{title})= $feed =~ /<title>(.*?)<\/title>/
		or die "Invalid feed file - no <title> tag.\n";

	($feed_data{language})= $feed =~ /<language>(.*?)<\/language>/
		or $feed_data{language} = "en";

	foreach my $key (keys %feed_data)
	{
		if ($feed_data{$key} =~ /\Q<![CDATA[\E/)
		{
			($feed_data{$key}) = $feed_data{$key} =~ /\Q<![CDATA[\E(.*)\Q]]>\E/;
		}
	}

	close($fh)
		|| warn "$file_path - close failed: $!\n";

	return %feed_data;
}


sub append_feed
{
	my $feeds_file_path = "feeds.json";
	
	my $file_contents = File::Slurper::read_text($feeds_file_path);

	if ($file_contents eq ""){$file_contents = "[]"};
	#print "hi".$file_contents;
	
	open (my $fh, '>', $feeds_file_path)
		or die "Can't open < $feeds_file_path: $! \n ";

	my %new_feed_hash = @_;

	my @file_content_array = @{JSON->new->utf8->decode(encode_utf8($file_contents))};
	
	my $is_already_there = 0;

	foreach my $feed_hash_ref (@file_content_array) {
		if (${$feed_hash_ref}{"title"} eq $new_feed_hash{"title"}) {
	     		$is_already_there = 1;
		}
	}
	
	if (!$is_already_there) {push @file_content_array, {%new_feed_hash}};

	my $new_file_content = to_json \@file_content_array, {pretty => 1} ;

	print $fh $new_file_content;

	close ($fh)
		|| warn "$feeds_file_path - close failed: $!\n";
}


sub add_feed
{
	my $url = $_[0];
	my $temp_file_path = $_[1];

	my %feed_data;

	%feed_data = parse_feed($temp_file_path);

	$feed_data{url} = $url;
	my $normalized_title = normalize_string($feed_data{title});

	my $cli_command;

	if (!(-d ".feeds"))
	{
		$cli_command = "mkdir .feeds";
		system($cli_command); #create .feeds directory
	}

	
	if (!(-d ".feeds/".$normalized_title))
	{
		$cli_command = "mkdir .feeds/".$normalized_title;
		system($cli_command); #create feed directory
	}

	if (!(-d ".feeds/".$normalized_title."/eps"))	
	{ 
		$cli_command = "mkdir .feeds/".$normalized_title."/eps";
		system($cli_command); #create downloaded episodes directory
	}
 
	$cli_command = "mv ".$temp_file_path." .feeds/".$normalized_title."/".$normalized_title.".xml";
	system($cli_command); #changes temporary *.xml file to correct name and moves it to feed directory;

	append_feed(%feed_data);
}


#programa de teste
#
#
#add_feed("https://rss.acast.com/vicegamingsnewpodcast", "waypoint_radio.xml");
