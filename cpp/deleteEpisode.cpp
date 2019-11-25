#include <iostream>
#include <string>
#include <cstdio>
#include <system_error>

#include "deleteEpisode.h"
#include "episode.h"

using namespace std;

void deleteEpisode(Episode episode, string episodeFilePath) {

    if(remove(episodeFilePath.c_str()) != 0 )
        cerr << "Unable to delete episode\n";

}
