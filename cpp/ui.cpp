#include <string>
#include <ncurses.h>
#include <iostream>
#include <stdlib.h>
#include <vector>
#include <algorithm>

#include "vector2.h"

using namespace std;

static Vector2 screenSize;

int init() {
	/* NCURSES START */
	initscr();
	noecho();
	cbreak();

	// get screen size
	getmaxyx(stdscr, screenSize.y, screenSize.x);
	
	return 0;
}

int callMenu(vector <string> options) {
	// create a window for the menu
	
	if (options.empty())
		return -1;

	WINDOW * menuwin = newwin(screenSize.y-4, screenSize.x - 6, 2, 5);
	box(menuwin, 0, 0);
	refresh();
	curs_set(0);
	wrefresh(menuwin);


	//makes it so we can use arrow keys
	keypad(menuwin, true);

	int choice;
	int highlight = 0;
	int size = options.size();
	int offset = 0;
	string url;
	bool scrolling = false;

	if (size > screenSize.y - 6) 
	{		
		size = screenSize.y - 6;
		scrolling = true;
	}

	while(1) 
	{


		for(int i = 0; i<size; i++)
		{
			if (i == highlight) 
			{
				wattron(menuwin, A_REVERSE);

			}			
			mvwprintw(menuwin, i+1, 1, options[i+offset].c_str());
			wclrtoeol(menuwin);
			wattroff(menuwin,  A_REVERSE);
			box(menuwin, 0, 0);
		}
		choice = wgetch(menuwin);

		switch(choice)
		{
			case KEY_UP:
				if (highlight > 0)
					highlight--;
				else if (offset > 0 && scrolling == true) 
				{	
					offset--;
					erase();
					refresh();
				}
								
				break;
			case KEY_DOWN:
				if (highlight < screenSize.y - 4 && highlight < size - 1)
					highlight++;
				else if (offset < size -1  && scrolling == true)		
				{
					offset++;	
					erase();
					refresh();

				}

				break;
			default:
				break;
		}


		if (choice == 10)
			break;
	}
	clear();
	refresh();
	endwin();
	return highlight + offset;
}


string getInput(string prompt) {
	// create a window for the prompt
	WINDOW * promptwin = newwin(12, screenSize.x - 6, screenSize.y-12, 5);
	box(promptwin, 0, 0);
	refresh();
	keypad(promptwin, true);
	wrefresh(promptwin);
	noecho();

	mvwprintw(promptwin, 1, 1, prompt.c_str());
	wattroff(promptwin,  A_REVERSE);

	int ch = mvwgetch(promptwin, 3, 1);
	string input;

	//echo();

	while( ch != '\n')
	{
		if ((ch == 127) || (ch == KEY_BACKSPACE))
		{
			clear();	
			if (!input.empty())
				input.pop_back();

		}
		else
			input.push_back(ch);
		
		
		box(promptwin, 0, 0);
		mvwprintw(promptwin, 1, 1, prompt.c_str());
		wmove(promptwin,4,1);
		wclrtoeol(promptwin);
		refresh();
		mvwprintw(promptwin, 4, 1, input.c_str());	
		ch = wgetch(promptwin);	
	}
	
	clear();
	refresh();
	endwin();
	return input;

} 

void showError(string error) {
	// create a window for the prompt
	WINDOW * errorwin = newwin(12, screenSize.x - 6, screenSize.y-12, 5);
	box(errorwin, 0, 0);
	refresh();
	keypad(errorwin, true);
	wrefresh(errorwin);
	noecho();

	mvwprintw(errorwin, 1, 1, error.c_str());
	wattroff(errorwin,  A_REVERSE);

	int ch = mvwgetch(errorwin, 3, 1);

	//echo();

	while( ch != '\n')
	{
		
	}
	
	endwin();
}

