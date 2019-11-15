#include <iostream>
#include <string>
#include <cstdlib>

#include "headers/playEpisode.h"
#include "headers/episode.h"
#include "headers/config.h"

using namespace std;

void playEpisode(Episode episode) {
    string episodeFilePath;
    string playEpisodeCommand = PLAY_EPISODE_DEFAULT_PROGRAM;
    
    playEpisodeCommand += " ";

    /* Perl:
     * episodeFilePath = generate_episode_file_path(episode.getFeedTitle(), episode);
     */

    playEpisodeCommand += episodeFilePath;
    if (system(playEpisodeCommand.c_str()) != 0)
        cerr << "Unable to play episode.\n";
}
