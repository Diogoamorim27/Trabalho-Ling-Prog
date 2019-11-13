#include <iostream>
#include <vector>

#include "headers/feed.h"
#include "headers/episode.h"

using namespace std;

int main() {
    Feed feed("decrepitos", "pt-BR", "decrepitos.com");

    if (feed.getEpisodes().empty())
        cout << "vazio" << endl;

    return 0;
}
