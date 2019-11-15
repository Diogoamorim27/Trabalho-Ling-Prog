#include <iostream>
#include <string>
#include <cstdio>
#include <system_error>

#include "headers/deleteEpisode.h"
#include "headers/episode.h"

using namespace std;

void deleteEpisode(Episode episode) {
    string episodeFilePath;

    /* Perl:
     * episodeFilePath = generate_episode_file_path(episode.getFeedTitle(), episode);
     */

    if(remove(episodeFilePath.c_str()) != 0 )
        cerr << "Unable to delete episode\n";
    //cout << "Episode deleted successfully." << endl;

    /* Perl:
     * delete_episode(episode.getFeedTitle(), episode.getTitle(), "episodes.json");
     */
}
