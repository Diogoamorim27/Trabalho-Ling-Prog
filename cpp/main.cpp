#include <string>
#include <ncurses.h>
#include <iostream>
#include <stdlib.h>
#include <EXTERN.h>
#include <perl.h>
#include <vector>

#include "perl_interface.h"
#include "downloadFeed.h"
#include "vector2.h"
#include "ui.h"

using namespace std;

int main (int argc, char** argv) {	
	PerlInterface perl("");
	perl.interpreter();

	init();
	noecho();
	vector <string> options = {	"Adicionar Feed",
					"Baixar Episódio",
					"Deletar Episódio",
					"Excluir Feed",
					"Mostrar Baixados",
					"Procurar Novos Episódios",
       					"Sair"				};


	int choice = callMenu(options);
	
	string feed_url;	
	string temp_feed_name;

	switch (choice)
	{
		case 0 : //adicionar feed
			feed_url = getInput("insira a url do feed \n");
			temp_feed_name = downloadFeed(feed_url); //baixa o arquivo xml do feed
			perl.add_feed(feed_url, temp_feed_name); //adiciona o feed ao arquvivo json
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
		
		case 7:
		break;
		default:
		break;
	}
	
	
	//cout << input<<endl;
	
	return 0;
}
