#include <iostream>
#include <string>
#include <cstdlib>

#include "playEpisode.h"
#include "episode.h"
#include "config.h"

using namespace std;

void playEpisode(Episode episode, string episodeFilePath) {
    string playEpisodeCommand = PLAY_EPISODE_DEFAULT_PROGRAM;
    
    playEpisodeCommand += " ";

    playEpisodeCommand += episodeFilePath;
    if (system(playEpisodeCommand.c_str()) != 0)
        cerr << "Unable to play episode.\n";
}
