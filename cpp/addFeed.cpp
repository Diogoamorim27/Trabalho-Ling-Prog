#include <iostream>
#include <fstream>
#include <cpr/cpr.h>
#include <string>

#include "headers/addFeed.h"

using namespace std;

void generate_random_string(string &str, const int len) {
    static const char alphanum[] =
        "0123456789"
        "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
        "abcdefghijklmnopqrstuvwxyz";

    srand(time(NULL));
    for (int i = 0; i < len; i++) {
        str.at(i) = alphanum[rand() % (sizeof(alphanum) - 1)];
    }

    str.at(len-1) = 0;
}

void addFeed(string feedUrl) {
    string tmp_file(TEMPORARY_FILE_NAME_LENGTH, ' ');
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
