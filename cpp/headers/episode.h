#ifndef EPISODE_H
#define EPISODE_H

#include <iostream>
#include <string>

using namespace std;

class Episode {
    public:
        Episode(string, string, string);
        string getTitle();
        string getDate();
        string getUrl();

    private:
        string title;
        string date;
        string url;
};

#endif
