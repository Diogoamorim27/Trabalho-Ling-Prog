#include <iostream>
#include <fstream>
#include <cpr/cpr.h>
#include <string>

#include "headers/downloadEpisode.h"

using namespace std;

void downloadEpisode(Episode episode) {
    ofstream file;
    string episodeFilePath;

    try {
        /* Perl:
         * episodeFilePath = generate_episode_file_path(episode.getFeedTitle(), episode);
         */

        file.open(episodeFilePath);
        cout << "Downloading episode..." << endl;
        auto response = cpr::Get(cpr::Url{episode.getUrl()});
        file << response.text;
        cout << "Download finished." << endl;
        file.close();

        /* Perl:
         * add_episode_to_json(episode.getFeedTitle(), episode, "episodes.json");
         */
    }
    catch (const ofstream::failure &e) {
        cerr << "Error creating file: " << e.what()
             << "\nUnable to download episode.\n";
    }
}
