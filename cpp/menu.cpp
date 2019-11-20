#include <string>
#include <ncurses.h>
#include <iostream>

using namespace std;

int main (int argc, char** argv) {
	/* NCURSES START */
	initscr();
	noecho();
	cbreak();

	// get screen size
	int yMax, xMax;
	getmaxyx(stdscr, yMax, xMax);

	// create a window for the menu
	WINDOW * menuwin = newwin(12, xMax - 6, yMax-12, 5);
	box(menuwin, 0, 0);
	refresh();
	wrefresh(menuwin);

	//makes it so we can use arrow keys
	keypad(menuwin, true);

	string options[6] = {	"Adicionar Feed",
				"Baixar Episodio",
				"Deletar Episodio",
				"Excluir Feed",
				"Mostrar Baixados",
				"Procurar Novos Episodios" };
	int choice;
	int highlight = 0;

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
				highlight--;
				break;
			case KEY_DOWN:
				highlight++;
				break;
			default:
				break;
		}
		if (choice == 10)
			break;
	}

	cout << options[highlight];

	endwin();
	return 0;
}
