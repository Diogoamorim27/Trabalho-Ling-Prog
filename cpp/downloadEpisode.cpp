#include <iostream>
#include <fstream>
#include <string>

#include "downloadEpisode.h"

using namespace std;

void downloadEpisode(Episode episode, string episodeFilePath) {
    ofstream file;
    string downloadEpisodeCommand = "wget -O ";

    try {

       	downloadEpisodeCommand += episodeFilePath;
       	downloadEpisodeCommand += " ";
       	downloadEpisodeCommand += episode.getUrl();
       	if (system(downloadEpisodeCommand.c_str()) != 0)
       	cerr << "Unable to download episode\n";

    }
    catch (const ofstream::failure &e) {
        cerr << "Error creating file: " << e.what()
             << "\nUnable to download episode.\n";
    }
}
