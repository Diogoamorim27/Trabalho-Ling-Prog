#include <iostream>
#include <fstream>
#include <cpr/cpr.h>
#include <string>
#include <stdexcept>

#include "headers/addFeed.h"

using namespace std;

void generateRandomString(string &str, const int len){
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
    string tmpFile(TEMPORARY_FILE_NAME_LENGTH, ' ');
    ofstream file;

    try {
        generateRandomString(tmpFile, TEMPORARY_FILE_NAME_LENGTH);
        try {
            file.open(tmpFile);
            cout << "Downloading feed..." << endl;
            auto response = cpr::Get(cpr::Url{feedUrl});
            file << response.text;
            cout << "Download finished." << endl;
            file.close();

           /* Perl:
            *
            * add_feed(feedUrl, tmpFile);
            *
            *
            */ 
        }
        catch (const ofstream::failure &e) {
            cerr << "Error creating file: " << e.what()
                 << "\nUnable to add feed.\n";
        }
    }
    catch (out_of_range &oor) {
        cerr << "Out of Range Error: " << oor.what()
             << "\nUnable to add feed.\n";
    }
}
