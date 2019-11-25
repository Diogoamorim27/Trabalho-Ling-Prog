#include <iostream>
#include <string>

#include "episode.h"

using namespace std;

Episode::Episode(string feedTitle, string title, string date, string url) : feedTitle (feedTitle), title (title), date (date), url (url) {}

void Episode::setFeedTitle(string title) {
	feedTitle = title;
}

void Episode::setTitle(string t) {
	title = t;
}

void Episode::setDate(string d){
	date = d;
}

void Episode::setUrl(string u){
	url = u;
}

string Episode::getFeedTitle() {
    return feedTitle;
}

string Episode::getTitle() {
    return title;
}

string Episode::getDate() {
    return date;
}

string Episode::getUrl() {
    return url;
}
