use strict;
use warnings;
use utf8;
use open qw(:std :encoding(UTF-8));
use Unicode::Collate;
use Encode qw( decode_utf8 );

require "./perl/get_episodes.pl";

#this subroutine searches episodes from a feed based on an input string
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

#test program
#my @result = search_episodes($ARGV[0], decode_utf8($ARGV[1]));

#for my $i (0 .. $#result){
#    print "$result[$i]{title}\n";
#}
