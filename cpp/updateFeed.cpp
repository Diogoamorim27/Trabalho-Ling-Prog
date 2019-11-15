#include <iostream>
#include <fstream>
#include <cpr/cpr.h>
#include <string>

#include "headers/updateFeed.h"

using namespace std;

void addFeed(string feedUrl) {
    ofstream file;

    generate_random_string(tmp_file, TEMPORARY_FILE_NAME_LENGTH);

    file.open(tmp_file);
    cout << "Downloading feed..." << endl;
    auto response = cpr::Get(cpr::Url{feedUrl});
    file << response.text;
    cout << "Download finished." << endl;
    file.close();

   /* Perl:
    *
    * add_feed(feedUrl, tmp_file);
    *
    *
    */ 
}
