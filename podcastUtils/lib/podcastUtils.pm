package podcastUtils;

#use 5.030000;
use strict;
use warnings;
use Carp;
use strict;
use warnings;
use JSON;
use File::Slurper;
use Data::Dumper; #debugging
use utf8;
use open qw(:std :encoding(UTF-8));
use Encode;
use Encode qw( decode_utf8 );
use Text::Unaccent::PurePerl;
use Unicode::Collate;
#use File::Copy;

require Exporter;
use AutoLoader;

our @ISA = qw(Exporter);

# Items to export into callers namespace by default. Note: do not export
# names by default without a very good reason. Use EXPORT_OK instead.
# Do not simply export all your public functions/methods/constants.

# This allows declaration	use podcastUtils ':all';
# If you do not need this, moving things directly into @EXPORT or @EXPORT_OK
# will save memory.
our %EXPORT_TAGS = ( 'all' => [ qw(
	
) ] );

our @EXPORT_OK = ( @{ $EXPORT_TAGS{'all'} } );

our @EXPORT = qw(
	add_episode_to_json
	parse_feed
	append_feed
	add_feed
	delete_episode 
 	delete_feed
	generate_episode_file_path
	get_downloaded_episodes_from_feed
	get_episodes
	get_feeds
	get_date
	get_most_recent
	get_new_episodes
	normalize_string
 	search_episodes
	call_perl_function_hash
	call_perl_function_string
	call_perl_function_void
);

our $VERSION = '0.01';

sub add_episode_to_json
{
	my $feed_name = $_[0];
	my %episode_data = %{$_[1]};   
	my $episodes_json_path = $_[2];

	

	my $file_contents = File::Slurper::read_text($episodes_json_path);

        $file_contents = encode_utf8($file_contents);

	my %feeds_in_file;

	if ($file_contents eq ""){$file_contents = "{}"};

	eval {%feeds_in_file = %{decode_json($file_contents)}}; 

	if (!($@ eq "")) {
		return $@;
	} else {

		%feeds_in_file = %{decode_json($file_contents)};

		open (my $fh, '>', $episodes_json_path)
			or die "Can't open < $episodes_json_path: $! \n ";
	
		$feeds_in_file{$feed_name}{$episode_data{"title"}} = \%episode_data;

		my $new_file_content = to_json (\%feeds_in_file, {pretty => 1});

		print $fh $new_file_content;

		close($fh)
			|| warn "$episodes_json_path - close failed: $!\n";
#
	}
}

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
	
		append_feed(%feed_data);
	}

	if (!(-d ".feeds/".$normalized_title."/eps"))	
	{ 
		$cli_command = "mkdir .feeds/".$normalized_title."/eps";
		system($cli_command); #create downloaded episodes directory
	}

	#	my $new_file_path = " .feeds/".$normalized_title."/".$normalized_title.".xml";
	#	move($temp_file_path,$new_file_path); #changes temporary *.xml file to correct name and moves it to feed directory;

	return $normalized_title;
}

sub delete_episode 
{
	my $episode_name = decode_utf8($_[1]);
	my $feed_name = decode_utf8($_[0]);
	my $episodes_json_path = $_[2];


	my $file_contents = File::Slurper::read_text($episodes_json_path);

        $file_contents = encode_utf8($file_contents);

	my %feeds_in_file;

	if ($file_contents eq ""){return ""};

	eval {%feeds_in_file = %{decode_json($file_contents)}}; 

	if (!($@ eq "")) {
		print "i shan't be printed!";
		return $@;
	} else {

		my %feeds_in_file = %{decode_json($file_contents)};

#		open (my $fh, '>', $episodes_json_path)
#			or die "Can't open < $episodes_json_path: $! \n ";

		my %episodes = %feeds_in_file{$feed_name};
		my @episodes_vector = values(%episodes);
		my %episodes_from_feed = %{$episodes_vector[0]};

		print "\n ------------ \n";
		delete $episodes_from_feed{$episode_name};

		$feeds_in_file{$feed_name} = \%episodes_from_feed;



		open (my $fh, '>', $episodes_json_path)
			or die "Can't open < $episodes_json_path: $! \n ";

		my $new_file_content = to_json \%feeds_in_file, {pretty => 1};

		print $fh $new_file_content;

		close($fh)
			|| warn "$episodes_json_path - close failed: $!\n";

	}
}

sub delete_feed
{

	my $feed_name = decode_utf8($_[0]);
	my $episodes_json_path = $_[1];
	my $feeds_json_path = $_[2];



	my $file_contents = File::Slurper::read_text($episodes_json_path);

	$file_contents = encode_utf8($file_contents);

	my %feeds_in_file;

	if ($file_contents eq ""){return ""};

	eval {%feeds_in_file = %{decode_json($file_contents)}}; 

	if (!($@ eq "")) {
		return $@;
	} else {

		my %feeds_in_file = %{decode_json($file_contents)};

	
		print "\n ------------ \n";
		delete $feeds_in_file{$feed_name};
	
	

		open (my $fh, '>', $episodes_json_path)
			or die "Can't open < $episodes_json_path: $! \n ";

		my $new_file_content = to_json \%feeds_in_file, {pretty => 1};

		print $fh $new_file_content;

		close($fh)
			|| warn "$episodes_json_path - close failed: $!\n";

		#

	}

	# ----- daqui pra cima funciona ---- #

	$file_contents = File::Slurper::read_text($feeds_json_path);

	$file_contents = encode_utf8($file_contents);

	if ($file_contents eq ""){return ""};

	eval {my @feeds_in_file = @{decode_json($file_contents)}}; 

	if (!($@ eq "")) {
		return $@;
	} else {

		my @feeds_in_file = @{decode_json($file_contents)};

		print "\n ------------ \n";
		
		my $i;

		my @new_feeds_in_file;

		for $i (@feeds_in_file) {
			if (!($feed_name eq ${$i}{"title"})) {
				push (@new_feeds_in_file, $i); 
			}
		}
	
	
		open (my $fh, '>', $feeds_json_path)
			or die "Can't open < $feeds_json_path: $! \n ";

		my $new_file_content = to_json \@new_feeds_in_file, {pretty => 1};

		print $fh $new_file_content;

		close($fh)
			|| warn "$feeds_json_path - close failed: $!\n";

		#

	}
}

sub generate_episode_file_path
{
	my $feed_title = $_[0];
	my %episode = %{$_[1]};

	my($extension) = $episode{url} =~ /([^.]*)$/; #gets content after last "." character
	my $episode_path = ".feeds/".normalize_string($feed_title)."/eps/".normalize_string($episode{title}).".".$extension;

	return $episode_path;
}


sub get_downloaded_episodes_from_feed
{
	my $feed_name = decode_utf8($_[0]);
	my $episodes_json_path = $_[1];


	my $file_contents = File::Slurper::read_text($episodes_json_path);

        $file_contents = encode_utf8($file_contents);

	my %feeds_in_file;

	if ($file_contents eq ""){return ""};

	eval {%feeds_in_file = %{decode_json($file_contents)}}; 

	if (!($@ eq "")) {
		return $@;
	} else {

		my %feeds_in_file = %{decode_json($file_contents)};

		my %episodes = %feeds_in_file{$feed_name};
		my @episodes_vector = values(%episodes);
		my $episodes_hash_ref = $episodes_vector[0]
                    or die "No episodes from the feed you are looking for.\n";
		my %episodes_hash = %{$episodes_hash_ref};
		my @final_vector = values(%episodes_hash);

	
		return \@final_vector;
	
	}
}

sub get_episodes
{
	my $feed_name = $_[0];      #string with the title of the chosen feed

	$feed_name = normalize_string($feed_name);

	my $file_path = ".feeds/".$feed_name."/".$feed_name.".xml";

	open (my $fh, "<", $file_path)
		or die "Can't open $file_path: $!\n";

	my $feed = "";

	while (my $reader = <$fh>)
	{
		$feed = $feed.$reader;
	}

	my @episodes;

	(my @episodes_data_raw) = $feed =~ /<item>(.*?)<\/item>/gs
		or die "No episode on feed\n";

	foreach my $episode (@episodes_data_raw)
	{
		my %episode_data;
		($episode_data{title}) = $episode =~ /<title>(.*?)<\/title>/;
		($episode_data{date}) = $episode =~ /<pubDate>(.*?)<\/pubDate>/;
		($episode_data{url}) = $episode =~ /<enclosure(.*?)\/>/;
		($episode_data{url}) = $episode_data{url} =~ /url="(.*?)"/;

		foreach my $key (keys %episode_data)
		{
			if ($episode_data{$key} =~ /\Q<![CDATA[\E/)
			{
				($episode_data{$key}) = $episode_data{$key} =~ /\Q<![CDATA[\E(.*)\Q]]>\E/;
			}
		}

		unshift @episodes, \%episode_data;
	}

	close($fh)
		|| warn "$file_path - close failed: $!\n";

	return @episodes;
}

sub get_feeds
{
    my $file_path = $_[0];

    open (my $fh, "<", $file_path)
        or die "Can't open $file_path: $!\n";

    my $json = "";

    while (my $reader = <$fh>)
    {
        $json = $json.$reader;
    }

    my @feeds;  #cria array de hashes de feeds
    my @feeds_data_raw;

    ($feeds_data_raw[0]) = $json =~ /\Q[\E(.*)\Q]\E/s  #guarda tudo que ta entre o primeiro e ultimo colchete na primeira posicao do array
        or die "Corrupted JSON file: feeds.json.\n";
    (@feeds_data_raw) = $feeds_data_raw[0] =~ /{(.*?)}/gs;  #percorre a string na primeira posicao e, para cada par "{}", pega o que ha dentro e guarda numa posicao do array

    foreach my $feed (@feeds_data_raw)
    {
        my %feed_data;
        ($feed_data{url}) = $feed =~ /"url"\s+:\s+"(.*?)"(,\n|\n)/;   #$feed_data{url} recebe o que esta entre "\"url\":\"" e "\"[,\n]" ignorando espacos em branco (\s+)
        ($feed_data{title}) = $feed =~ /"title"\s+:\s+"(.*?)"(,\n|\n)/;
        ($feed_data{language}) = $feed =~ /"language"\s+:\s+"(.*?)"(,\n|\n)/;
        unshift @feeds, \%feed_data;    #guarda o hash do feed na primeira posicao de @feeds, deslocando os outros elementos para a direita
    }

    close($fh)
        or warn "$file_path - close failed: $!\n";

    return @feeds;
}

sub get_date{
    my $pubDate = $_[0];

    my %months = ("Jan", 1,
               "Feb", 2, 
               "Mar", 3, 
               "Apr", 4, 
               "May", 5, 
               "Jun", 6, 
               "Jul", 7, 
               "Aug", 8, 
               "Sep", 9, 
               "Oct", 10, 
               "Nov", 11, 
               "Dec", 12);

    my @date_words = split(/ /, $pubDate);

    my %date;

    $date{day} = int($date_words[1]);
    $date{month} = $months{$date_words[2]};
    $date{year} = int($date_words[3]);
    my @time = split(/:/, $date_words[4]);
    $date{hour} = $time[0] + int($date_words[5])*0.01; #hour + timezone
    $date{minute} = $time[1];
    $date{second} = $time[2];

    return \%date;
}

sub get_most_recent{
    my @episodes = @{$_[0]};  #array of hashes with downloaded episodes data
    my $most_recent = 0;
    my @date;

    for my $i (0 .. $#episodes){
        $date[$i] = get_date($episodes[$i]{date});
        if ($i != 0){
            if ($date[$i]{year} > $date[$most_recent]{year}){
                $most_recent = $i;
            }
            elsif (($date[$i]{year} == $date[$most_recent]{year}) and
                   ($date[$i]{month} > $date[$most_recent]{month})){
                $most_recent = $i;
            }
            elsif (($date[$i]{year} == $date[$most_recent]{year}) and 
                   ($date[$i]{month} == $date[$most_recent]{month}) and
                   ($date[$i]{day} > $date[$most_recent]{day})){
                $most_recent = $i;
            }
            elsif (($date[$i]{year} == $date[$most_recent]{year}) and 
                   ($date[$i]{month} == $date[$most_recent]{month}) and
                   ($date[$i]{day} == $date[$most_recent]{day}) and
                   ($date[$i]{hour} > $date[$most_recent]{hour})){
                $most_recent = $i;
            }
            elsif (($date[$i]{year} == $date[$most_recent]{year}) and 
                   ($date[$i]{month} == $date[$most_recent]{month}) and
                   ($date[$i]{day} == $date[$most_recent]{day}) and
                   ($date[$i]{hour} == $date[$most_recent]{hour}) and
                   ($date[$i]{minute} > $date[$most_recent]{minute})){
                $most_recent = $i;
            }
            elsif (($date[$i]{year} == $date[$most_recent]{year}) and 
                   ($date[$i]{month} == $date[$most_recent]{month}) and
                   ($date[$i]{day} == $date[$most_recent]{day}) and
                   ($date[$i]{hour} == $date[$most_recent]{hour}) and
                   ($date[$i]{minute} == $date[$most_recent]{minute}) and
                   ($date[$i]{second} > $date[$most_recent]{second})){
                $most_recent = $i;
            }
        }
    }
    return $episodes[$most_recent];
}

sub get_new_episodes{
    my $feed_name = $_[0];      #string with the title of the chosen feed
    my $episodes_json_path = $_[1];

    my @downloaded_episodes = @{get_downloaded_episodes_from_feed($feed_name, $episodes_json_path)};

    #hash with data from most recent downloaded episode
    my %most_recent_downloaded = %{get_most_recent(\@downloaded_episodes)};

    $feed_name = normalize_string($feed_name);

    my $file_path = ".feeds/".$feed_name."/".$feed_name.".xml";

    open (my $fh, "<", $file_path)
            or die "Can't open $file_path: $!\n";

    my $feed = "";

    while (my $reader = <$fh>){
            $feed = $feed.$reader;
    }

    my @episodes;

    (my @episodes_data_raw) = $feed =~ /<item>(.*?)<\/item>/gs
            or die "No episode on feed\n";

    my $found = 0;
    LOOP: foreach my $episode (@episodes_data_raw){
            my %episode_data;
            ($episode_data{title}) = $episode =~ /<title>(.*?)<\/title>/;
            ($episode_data{date}) = $episode =~ /<pubDate>(.*?)<\/pubDate>/;
            ($episode_data{url}) = $episode =~ /<enclosure(.*?)\/>/;
            ($episode_data{url}) = $episode_data{url} =~ /url="(.*?)"/;

            foreach my $key (keys %episode_data){
                    if ($episode_data{$key} =~ /\Q<![CDATA[\E/){
                            ($episode_data{$key}) = $episode_data{$key} =~ /\Q<![CDATA[\E(.*)\Q]]>\E/;
                    }
            }
            if ($episode_data{title} eq $most_recent_downloaded{title}){
                    $found = 1;
            }
            last LOOP if ($found); #stops if finds most recent downloaded episode

            unshift @episodes, \%episode_data;
    }

    close($fh)
            || warn "$file_path - close failed: $!\n";
    if ($found == 0){
            @episodes = (); 
    }
    return \@episodes;
}

sub normalize_string
{ 
	my $string = $_[0]; 

	my $normalized = unac_string("UTF-8", encode_utf8($string));

	$normalized =~ s/ /_/g;
	$normalized = lc $normalized;

	return $normalized; 
}

sub search_episodes{
    my $feed_name = $_[0];
    my @search_entry = split(/ /, $_[1]);     #get each word separated by a space from the search entry and stores it as an individual string in an array
    my @episodes = get_episodes($feed_name);
    
    my @results;

    my $collate = Unicode::Collate->new(
                level => 1,     #ignores diacritics
                normalization => undef
    );

    my $match_counter;
    my $j;

    #searches each word from the search entry in each episode title
    for my $i (0 .. $#episodes){
        $match_counter = 0;
        $j = 0;
        while ($j <= $#search_entry){
            if (my @matches = $collate->gmatch($episodes[$i]{title}, $search_entry[$j])){
                #only counts as a match if it matches the whole word
                if ($episodes[$i]{title} =~ /\b($matches[0])\b/i){
                    $match_counter++;
                }
            }
            $j++;
        }
        #if more than half of the words in the search entry matches, the episode enters the results array
        if ($match_counter > ($#search_entry + 1)/2){
            push @results, $episodes[$i];
        }
    }

    return @results;
}

sub call_perl_function_hash {
    if ($_[0] eq "get_episodes") {
        my @get_episodes = get_episodes(decode_utf8($_[1]));
        my @get_episodes_str;
        my $j = 0;
        for my $i (0 .. $#get_episodes) {
            $get_episodes_str[$j] = $get_episodes[$i]{title};
            $get_episodes_str[$j+1] = $get_episodes[$i]{date};
            $get_episodes_str[$j+2] = $get_episodes[$i]{url};
            $j = $j + 3;
        }
        return @get_episodes_str;
    }
    if ($_[0] eq "get_downloaded_episodes_from_feed") {
        my @get_downloaded_episodes = @{get_downloaded_episodes_from_feed(decode_utf8($_[1]), "episodes.json")};
        my @get_downloaded_episodes_str;
        my $j = 0;
        for my $i (0 .. $#get_downloaded_episodes) {
            $get_downloaded_episodes_str[$j] = $get_downloaded_episodes[$i]{title};
            $get_downloaded_episodes_str[$j+1] = $get_downloaded_episodes[$i]{date};
            $get_downloaded_episodes_str[$j+2] = $get_downloaded_episodes[$i]{url};
            $j = $j + 3;
        }
        return @get_downloaded_episodes_str;
    }
    if ($_[0] eq "get_feeds") {
        my @get_feeds = get_feeds($_[1]);
        my @get_feeds_str;
        my $j = 0;
        for my $i (0 .. $#get_feeds) {
            $get_feeds_str[$j] = $get_feeds[$i]{title};
            $get_feeds_str[$j+1] = $get_feeds[$i]{language};
            $get_feeds_str[$j+2] = $get_feeds[$i]{url};
            $j = $j + 3;
        }
        return @get_feeds_str;
    }
    if ($_[0] eq "search_episodes") {
        my @search_episodes = search_episodes(decode_utf8($_[1]), decode_utf8($_[2]));
        my @search_episodes_str;
        my $j = 0;
        for my $i (0 .. $#search_episodes) {
            $search_episodes_str[$j] = $search_episodes[$i]{title};
            $search_episodes_str[$j+1] = $search_episodes[$i]{date};
            $search_episodes_str[$j+2] = $search_episodes[$i]{url};
            $j = $j + 3;
        }
        return @search_episodes_str;
    }
    if ($_[0] eq "get_new_episodes") {
        my @get_new_episodes = @{get_new_episodes(decode_utf8($_[1]),"./episodes.json")};
        my @get_new_episodes_str;
        my $j = 0;
        for my $i (0 .. $#get_new_episodes) {
            $get_new_episodes_str[$j] = $get_new_episodes[$i]{title};
            $get_new_episodes_str[$j+1] = $get_new_episodes[$i]{date};
            $get_new_episodes_str[$j+2] = $get_new_episodes[$i]{url};
            $j = $j + 3;
        }
        return @get_new_episodes_str;
    }
    warn "Unknown function.\n";
}

sub call_perl_function_string {
    if ($_[0] eq "generate_episode_file_path") {
        my %episode;
        $episode{title} = decode_utf8($_[2]);
        $episode{url} = decode_utf8($_[3]);
        return generate_episode_file_path(decode_utf8($_[1]), \%episode);
    }
    warn "Unknown function.\n";
}

sub call_perl_function_void {
    if ($_[0] eq "add_episode_to_json") {
        my %episode;
        $episode{title} = decode_utf8($_[3]);
        $episode{date} = decode_utf8($_[4]);
        $episode{url} = decode_utf8($_[5]);
        add_episode_to_json(decode_utf8($_[1]), \%episode, $_[2]);
    }
    else {warn "Unknown function.\n";}
}


# Preloaded methods go here.

# Autoload methods go after =cut, and are processed by the autosplit program.

1;
__END__
# Below is stub documentation for your module. You'd better edit it!

=head1 NAME

podcastUtils - Perl extension for blah blah blah

=head1 SYNOPSIS

  use podcastUtils;
  blah blah blah

=head1 DESCRIPTION

Stub documentation for podcastUtils, created by h2xs. It looks like the
author of the extension was negligent enough to leave the stub
unedited.

Blah blah blah.

=head2 EXPORT

None by default.



=head1 SEE ALSO

Mention other useful documentation such as the documentation of
related modules or operating system documentation (such as man pages
in UNIX), or any relevant external documentation such as RFCs or
standards.

If you have a mailing list set up for your module, mention it here.

If you have a web site set up for your module, mention it here.

=head1 AUTHOR

diogo, E<lt>diogo@nonetE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2019 by diogo

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.30.0 or,
at your option, any later version of Perl 5 you may have available.


=cut
