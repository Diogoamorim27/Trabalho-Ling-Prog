use strict;
use warnings;

require "./perl/normalize_string.pl";

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

#programa de teste
#my @episodes = get_episodes("Decrépitos");

#for my $i (0 .. $#episodes)
#{
	#	for my $attribute ( keys %{$episodes[$i]} )
	#{
	#	print "$episodes[$i]{$attribute}\n";
	#}
	
#	print "$episodes[$i]{title}\n";
#}

1;
