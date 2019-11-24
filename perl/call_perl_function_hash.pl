use strict;
use warnings;
require "./perl/get_episodes.pl";
require "./perl/get_downloaded_episodes.pl";
require "./perl/get_feeds.pl";
require "./perl/search_episode.pl";

# This subroutine calls another perl  subroutine that returns an array of hashes
# and converts its return value to an array of strings, so that the C++ can 
# understand it.
sub call_perl_function_hash {
    if ($_[0] eq "get_episodes") {
        my @get_episodes = get_episodes($_[1]);
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
    if ($_[0] eq "get_dowloaded_episodes_from_feed") {
        my @get_downloaded_episodes = @{get_downloaded_episodes_from_feed($_[1], $_[2])};
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
        my @search_episodes = search_episodes($_[1], $_[2]);
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
        my @get_new_episodes = @{get_new_episodes($_[1])};
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
1;
