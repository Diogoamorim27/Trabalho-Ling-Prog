use strict;
use warnings;
require "./perl/generate_episode_file_path.pl";

# This subroutine calls another perl subroutine that returns a string,
# but first creates a hash based on the strings passed by C++ and passes it as
# an argument to the called function.
sub call_perl_function_string {
    if ($_[0] == "generate_episode_file_path") {
        my %episode;
        $episode{title} = $_[2];
        $episode{url} = $_[3];
        return generate_episode_file_path($_[1], \%episode);
    }
    warn "Unknown function.\n";
}
1;
