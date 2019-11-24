#ifndef ADD_FEED_H
#define ADD_FEED_H

#include <iostream>
#include <string>

#define TEMPORARY_FILE_NAME_LENGTH  16

using namespace std;

void generateRandomString(string &, const int);

string downloadFeed(string feedUrl);

#endif
