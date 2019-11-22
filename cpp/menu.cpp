#include <string>
#include <ncurses.h>
#include <iostream>
#include <stdlib.h>
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

int callMenu(string* options) {
	// create a window for the menu
	WINDOW * menuwin = newwin(12, screenSize.x - 6, screenSize.y-12, 5);
	box(menuwin, 0, 0);
	refresh();
	curs_set(0);
	wrefresh(menuwin);


	//makes it so we can use arrow keys
	keypad(menuwin, true);

	int choice;
	int highlight = 0;

	string url;

	while(1) 
	{
		for(int i = 0; i<6; i++)
		{
			if (i == highlight) 
			{
				wattron(menuwin, A_REVERSE);

			}
			mvwprintw(menuwin, i+1, 1, options[i].c_str());
			wattroff(menuwin,  A_REVERSE);
		}
		choice = wgetch(menuwin);

		switch(choice)
		{
			case KEY_UP:
				if (highlight > 0)
					highlight--;
				break;
			case KEY_DOWN:
				if (highlight < 6 - 1)
					highlight++;
				break;
			default:
				break;
		}
		
		if (choice == 10)
			break;
	}

	endwin();
	return highlight;
}

string getInput(string prompt) {
	// create a window for the prompt
	WINDOW * promptwin = newwin(12, screenSize.x - 6, screenSize.y-12, 5);
	box(promptwin, 0, 0);
	refresh();
	wrefresh(promptwin);
	keypad(promptwin, true);
	
	mvwprintw(promptwin, 1, 1, prompt.c_str());
	//wattroff(menuwin,  A_REVERSE);

	int ch = mvwgetch(promptwin, 3, 1);
	string input;
	
	while( ch != '\n')
	{
		input.push_back(ch);
		mvwprintw(promptwin, ch, 3, 1);
		ch = wgetch(promptwin);		
	}
	
	endwin();
	return input;

} 

int main (int argc, char** argv) {	
	init();
	
	string options[6] = {	"Adicionar Feed",
				"Baixar Episódio",
				"Deletar Episódio",
				"Excluir Feed",
				"Mostrar Baixados",
				"Procurar Novos Episódios" };


	int choice = callMenu(options);
		
	string input = getInput("insira a url do feed \n");
	cout << input<<endl;
	
	return 0;
}

int insert_url() {
/*	int ch = wgetch(menuwin);
				
					*/
}

