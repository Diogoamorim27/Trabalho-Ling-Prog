#include <iostream>
#include <string>
#include <cstdlib>

#include "deleteFeed.h"
#include "feed.h"

using namespace std;

void deleteFeed(Feed feed) {
    string feedDirectory;
    string removeDirectory = "rm -rf ";

    feedDirectory = ".feeds/" + feedDirectory;
    removeDirectory += feedDirectory;
    if (system(removeDirectory.c_str()) != 0)
        cerr << "Unable to remove feed\n";

}
