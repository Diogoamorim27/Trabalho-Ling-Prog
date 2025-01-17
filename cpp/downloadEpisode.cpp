#include <iostream>
#include <fstream>
#include <string>
#include <cstring>

#include "downloadEpisode.h"

using namespace std;

void downloadEpisode(Episode episode, string episodeFilePath) {
    string downloadEpisodeCommand = "wget -O ";

    episodeFilePath = "\"" + episodeFilePath + "\"";
    downloadEpisodeCommand += episodeFilePath;
    downloadEpisodeCommand += " ";
    downloadEpisodeCommand += episode.getUrl();
    //cout << downloadEpisodeCommand << endl;
    if (system(downloadEpisodeCommand.c_str()) < 0){
        cerr << "Unable to download episode\n";
        cout << strerror(errno) << endl;
    }
}
