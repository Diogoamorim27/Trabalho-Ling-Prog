#include <iostream>
#include <fstream>
#include <cpr/cpr.h>
#include <string>

#include "downloadEpisode.h"

using namespace std;

void downloadEpisode(Episode episode) {
    ofstream file;
    string episodeFilePath;
    string downloadEpisodeCommand = "curl ";

    try {
        /* Perl:
         * episodeFilePath = generate_episode_file_path(episode.getFeedTitle(), episode);
         */

        downloadEpisodeCommand += episode.getUrl();
        downloadEpisodeCommand += " --output ";
        downloadEpisodeCommand += episodeFilePath;

        if (system(downloadEpisodeCommand.c_str()) != 0) {
            //try with wget instead
            downloadEPisodeCommand.clear();
            downloadEpisodeCommand = "wget -O ";
            downloadEpisodeCommand += episodeFilePath;
            downloadEpisodeCommand += " ";
            downloadEpisodeCommand += episode.getUrl();
            if (system(downloadEpisodeCommand.c_str()) != 0)
                cerr << "Unable to download episode\n";
        }

        /* Perl:
         * add_episode_to_json(episode.getFeedTitle(), episode, "episodes.json");
         */
    }
    catch (const ofstream::failure &e) {
        cerr << "Error creating file: " << e.what()
             << "\nUnable to download episode.\n";
    }
}
