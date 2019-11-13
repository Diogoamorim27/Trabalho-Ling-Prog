#ifndef FEED_H
#define FEED_H

#include <iostream>
#include <string>
#include <vector>

#include "episode.h"

using namespace std;

class Feed {
    public:
        Feed(string, string, string);
        ~Feed();
        string getTitle();
        string getLanguage();
        string getUrl();
        vector<Episode *> getEpisodes();
        void addEpisode(Episode *);

    private:
        string title;
        string language;
        string url;
        vector<Episode *> episodes;
};

#endif
