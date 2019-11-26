#include <iostream>
#include <string>
#include <vector>

#include "feed.h"

using namespace std;

Feed::Feed(string title, string language, string url) : title (title), language (language), url (url) {
}

void Feed::setTitle(string t){
	title = t;
}

void Feed::setUrl(string u){
	url = u;
}

void Feed::setLanguage(string l){
	language = l;
}


Feed::~Feed() {
    if (!episodes.empty()){
        for (long unsigned int i = 0; i < episodes.size(); i++)
            delete episodes.at(i);
        episodes.clear();
    }
}

string Feed::getTitle() {
    return title;
}

string Feed::getLanguage() {
    return language;
}

string Feed::getUrl() {
    return url;
}

vector<Episode *> Feed::getEpisodes() {
    return episodes;
}

void Feed::addEpisode(Episode *episode) {
    episodes.push_back(episode);
}
