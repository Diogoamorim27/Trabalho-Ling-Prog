#include <iostream>
#include <string>

using namespace std;

Episode::Episode(string title, string date, string url, string feedTitle) : title (title), date (date), url (url) {}

string Episode::getTitle() {
    return title;
}

string Episode::getDate() {
    return date;
}

string Episode::getUrl() {
    return url;
}
