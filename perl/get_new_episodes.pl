use strict;
use warnings;
use utf8;
use open qw(:std :encoding(UTF-8));
use Encode qw( encode_utf8 );

require "./perl/normalize_string.pl";
require "./perl/get_downloaded_episodes.pl";

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


#programa de teste

my @new_eps = @{get_new_episodes("Decrépitos", "episodes.json")};

for my $i (0 .. $#new_eps)
{
		for my $attribute ( keys %{$new_eps[$i]} )
	{
		print "$new_eps[$i]{$attribute}\n";
	}
        print "--------------\n";	
}
