use strict;
use warnings;

sub get_episodes
{
	my $file_path = $_[0];      #string with the path to *.xml file

	open (FEED, $file_path) or die "Cant open $file_path!";

	my $feed = "";

	while (my $reader = <FEED>)
	{
		$feed = $feed.$reader;
	}

	my @episodes;

	(my @episodes_data_raw) = $feed =~ /<item>(.*?)<\/item>/gs;

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

	close(FEED);

	return @episodes;
}

#programa de teste
my @episodes = get_episodes("./decrepitos.xml");

for my $i (0 .. $#episodes)
{
	#	for my $attribute ( keys %{$episodes[$i]} )
	#{
	#	print "$episodes[$i]{$attribute}\n";
	#}
	
	print "$episodes[$i]{title}\n";
}

1;
