#ifndef DOWNLOAD_FEED_H
#define DOWNLOAD_FEED_H

#include <iostream>
#include <string>

#define TEMPORARY_FILE_NAME_LENGTH  16

using namespace std;

void generateRandomString(string &, const int);

string downloadFeed(string feedUrl);

size_t writeFunction(void *, size_t, size_t, string *);

#endif
