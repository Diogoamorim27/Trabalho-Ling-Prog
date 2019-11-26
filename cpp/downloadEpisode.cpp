#include <iostream>
#include <fstream>
#include <string>

#include "downloadEpisode.h"

using namespace std;

void downloadEpisode(Episode episode, string episodeFilePath) {
    string downloadEpisodeCommand = "wget -O ";

    downloadEpisodeCommand += episodeFilePath;
    downloadEpisodeCommand += " ";
    downloadEpisodeCommand += episode.getUrl();
    cout << downloadEpisodeCommand << endl;
    if (system(downloadEpisodeCommand.c_str()) != 0)
        cerr << "Unable to download episode\n";
}
