#include <string>
#include <ncurses.h>
#include <iostream>
#include <stdlib.h>
//#include <perl.h>
//#include <EXTERN.h>

#include "downloadFeed.h"
#include "vector2.h"
#include "ui.h"

using namespace std;

int main (int argc, char** argv) {	
//	PerlInterface perl("");
//	perl.interpreter();

	init();
	noecho();
	string options[6] = {	"Adicionar Feed",
				"Baixar Episódio",
				"Deletar Episódio",
				"Excluir Feed",
				"Mostrar Baixados",
				"Procurar Novos Episódios" };


	int choice = callMenu(options);
	
	string feed_url;	

	switch (choice)
	{
		case 0 : //adicionar feed
			feed_url = getInput("insira a url do feed \n");
			cout << downloadFeed(feed_url); //downloads feed xml	
			break;
		case 1:
		break;
		
		case 2:
		break;
		
		case 3:
		break;
		
		case 4:
		break;
		
		case 5:
		
		break;
		
		default:
		break;
	}
	
	
	//cout << input<<endl;
	
	return 0;
}
