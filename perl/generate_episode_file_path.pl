use strict;
use warnings;

require "./perl/normalize_string.pl";

#this subroutine is used to get the episode file extension from its url
sub generate_episode_file_path
{
	my $feed_title = $_[0];
	my %episode = %{$_[1]};

	my($extension) = $episode{url} =~ /([^.]*)$/; #gets content after last "." character
	my $episode_path = ".feeds/".normalize_string($feed_title)."/eps/".normalize_string($episode{title}).".".$extension;

	return $episode_path;
}


#test program:

#my %episode;
#$episode{title} = "Decrépitos 230 - Respondendo Testes da Capricho 5";
#$episode{url} = "https://media.blubrry.com/decrepitos/decrepitos.com/podcast/20    19/decrepitos_230_capricho_5.mp3";

#my $path = generate_episode_file_path("Decrépitos", \%episode);
#print "$path\n";
