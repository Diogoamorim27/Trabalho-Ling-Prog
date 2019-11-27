#include <iostream>
#include <fstream>
#include <string>
#include <curl/curl.h>
#include <stdexcept>
#include <cstdio>
#include <cstring>

#include "downloadFeed.h"

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


size_t writeFunction(void *ptr, size_t size, size_t nmemb, string *data) {
    data->append((char *) ptr, size * nmemb);
    return size * nmemb;
}

string downloadFeed(string feedUrl, string &error) {
    string tmpFile(TEMPORARY_FILE_NAME_LENGTH, ' ');
    ofstream file;
    string responseString;
    string headerString;
    char* url;
    long responseCode;
    double elapsed;

    error = "";
    generateRandomString(tmpFile, TEMPORARY_FILE_NAME_LENGTH);
    auto curl = curl_easy_init();
    if (curl) {
        CURLcode res;
        char errbuf[CURL_ERROR_SIZE];
        curl_easy_setopt(curl, CURLOPT_URL, feedUrl.c_str());
        curl_easy_setopt(curl, CURLOPT_ERRORBUFFER, errbuf);
        errbuf[0] = 0;
        curl_easy_setopt(curl, CURLOPT_NOPROGRESS, 1L);
        curl_easy_setopt(curl, CURLOPT_MAXREDIRS, 50L);
        curl_easy_setopt(curl, CURLOPT_TCP_KEEPALIVE, 1L);
        
        curl_easy_setopt(curl, CURLOPT_WRITEFUNCTION, writeFunction);
        curl_easy_setopt(curl, CURLOPT_WRITEDATA, &responseString);
        curl_easy_setopt(curl, CURLOPT_HEADERDATA, &headerString);
        
        
        res = curl_easy_perform(curl);
        curl_easy_getinfo(curl, CURLINFO_RESPONSE_CODE, &responseCode);
        curl_easy_getinfo(curl, CURLINFO_TOTAL_TIME, &elapsed);
        curl_easy_getinfo(curl, CURLINFO_EFFECTIVE_URL, &url);

        if (res == CURLE_OK) {
            file.open(tmpFile);
            file << responseString;
            file.close();
        }
        else {
            size_t len = strlen(errbuf);
            error = "libcurl: (" + to_string(res) + ") ";
            if (len)
                error = error + errbuf;
            else
                error = error + curl_easy_strerror(res);
        }
        curl_easy_cleanup(curl);
        curl = NULL;
    }

    return tmpFile;
}
