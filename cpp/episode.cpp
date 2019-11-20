#include <iostream>
#include <string>

#include "episode.h"

using namespace std;

Episode::Episode(string feedTitle, string title, string date, string url) : feedTitle (feedTitle), title (title), date (date), url (url) {}

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
