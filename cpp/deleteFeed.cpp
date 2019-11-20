#include <iostream>
#include <string>
#include <cstdlib>

#include "deleteFeed.h"
#include "feed.h"

using namespace std;

void deleteFeed(Feed feed) {
    string feedDirectory;
    string removeDirectory = "rm -rf ";

    /* Perl:
     * feedDirectory = normalize_string(feed.getTitle());
     */

    feedDirectory = ".feeds/" + feedDirectory;
    removeDirectory += feedDirectory;
    if (system(removeDirectory.c_str()) != 0)
        cerr << "Unable to remove feed\n";
    //cout << "Feed removed successfully" << endl;

    /* Perl:
     * delete_feed(feed.getTitle(), "episodes.json", "feeds.json");
     */
}
