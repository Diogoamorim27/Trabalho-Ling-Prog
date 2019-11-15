#include <iostream>

#include "../headers/addFeed.h"

using namespace std;

int main(int argc, char **argv) {
    if (argc != 2){
        cout << "./addFeed url_feed" << endl;
        return -1;
    }

    addFeed(argv[1]);

    return 0;
}
