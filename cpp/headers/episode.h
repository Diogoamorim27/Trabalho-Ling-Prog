#ifndef EPISODE_H
#define EPISODE_H

#include <iostream>
#include <string>

using namespace std;

class Episode {
    public:
        Episode(string, string, string, string);
        string getFeedTitle();
        string getTitle();
        string getDate();
        string getUrl();

    private:
        string feedTitle;
        string title;
        string date;
        string url;
};

#endif
