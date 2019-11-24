#include <string>
#include <ncurses.h>
#include <iostream>
#include <stdlib.h>
#include <EXTERN.h>
#include <perl.h>
#include <vector>
#include <stdexcept>
#include <fstream>

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
                                        "Atualizar Feed",
					"Baixar Episódio",
					"Deletar Episódio",
					"Excluir Feed",
					"Mostrar Baixados",
					"Procurar Novos Episódios",
       					"Sair"				};


	int choice = callMenu(options);
	
	string feed_url;	
	string temp_feed_name;
	vector <string> feeds_string;
	switch (choice)
	{
		case 0 : //adicionar feed
			feed_url = getInput("Insira a url do feed.\n");
                        try {
			    temp_feed_name = downloadFeed(feed_url); //baixa o arquivo xml do feed
                        }
                        catch (out_of_range &oor) {
                            cerr << "Out of Range Error: " << oor.what()
                                 << "\nUnable to add feed.\n";
                        }
                       	catch (const ofstream::failure &e) {
                            cerr << "Error creating file: " << e.what()
                                 << "\nUnable to add feed.\n";
                        }
			perl.add_feed(feed_url, temp_feed_name); //cria diretorio do feed e adiciona no json
			break;
		case 1:
			feeds_string = perl.call_perl_function_hash("get_feeds", "./feeds.json");
			for (int i=0; i<feeds_string.size(); i++)
				cout<<feeds_string[i]<<endl;	
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
