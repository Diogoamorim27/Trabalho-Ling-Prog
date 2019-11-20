use strict;
use warnings;
require "./perl/add_episode.pl";

# This subroutine calls another perl subroutine that don't return anything,
# but first creates a hash based on the strings passed by C++ and passes it as
# an argument to the called function.
sub call_perl_function_void {
    if ($_[0] == "add_episode_to_json") {
        my %episode;
        $episode{title} = $_[3];
        $episode{date} = $_[4];
        $episode{url} = $_[5];
        add_episode_to_json($_[1], \%episode, $_[2]);
    }
    warn "Unknown function.\n";
}
1;
