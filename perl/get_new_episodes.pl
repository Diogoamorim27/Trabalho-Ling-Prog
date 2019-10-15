use strict;
use warnings;

require "./perl/normalize_string.pl";

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
                print "ok2\n";
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
        my %most_recent_downloaded = %{$_[1]};  #hash with data from most recent downloaded episode

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
                last LOOP if ($episode_data{title} eq $most_recent_downloaded{title}); #stops if finds most recent downloaded episode

		unshift @episodes, \%episode_data;
	}

	close($fh)
		|| warn "$file_path - close failed: $!\n";

	return \@episodes;
}

#programa de teste

#my %episode1;
#$episode1{title} = "Decrépitos 230 - Respondendo Testes da Capricho 5";
#$episode1{url} = "https://media.blubrry.com/decrepitos/decrepitos.com/podcast/2019/decrepitos_230_capricho_5.mp3";
#$episode1{date} = "Tue, 05 Mar 2018 18:00:00 -0200";

#my %episode2;
#$episode2{title} = "345 Teaser - Conspiracy at the Highest Level";
#$episode2{url} = "https://media.blubrry.com/decrepitos/decrepitos.com/podcast/2019/decrepitos_230_capricho_5.mp3";
#$episode2{date} = "Mon, 05 Mar 2019 18:10:00 -0300";

#my @episodes;
#unshift @episodes, \%episode1;
#unshift @episodes, \%episode2;

#print "$episodes[1]{title}\n";

#my %most_recent = %{get_most_recent(\@episodes)};
#print "mais recente: $most_recent{title}\n";

#my @new_eps = @{get_new_episodes("Chapo Trap House", \%most_recent)};

#for my $i (0 .. $#new_eps)
#{
#		for my $attribute ( keys %{$new_eps[$i]} )
#	{
#		print "$new_eps[$i]{$attribute}\n";
#	}
	
#}

1;
