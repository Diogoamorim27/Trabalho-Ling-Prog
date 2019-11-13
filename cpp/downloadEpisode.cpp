#include <iostream>
#include <fstream>
#include <cpr/cpr.h>
#include <string>

#include "headers/downloadEpisode.h"

using namespace std;

void downloadEpisode(Episode episode, string feedTitle) {
    ofstream file;
    string episodeFilePath;

    /* Perl:
     * episodeFilePath = generate_episode_file_path(feedTitle(), episode);
     */

    file.open(episodeFilePath);
    cout << "Downloading episode..." << endl;
    auto response = cpr::Get(cpr::Url{episode.getUrl()});
    file << response.text;
    cout << "Download finished." << endl;
    file.close();

    /* Perl:
     * add_episode_to_json(feedTitle, episode, "episodes.json");
     */
}
