#include <string>
#include <ncurses.h>
#include <iostream>
#include <stdlib.h>
#include <EXTERN.h>
#include <perl.h>
#include <vector>
#include <stdexcept>
#include <fstream>
#include <stdio.h>

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
	
	string move_file_command;
	string new_feed_path;
	string feed_url;	
	string feed_name;
	string feed_nrm_title;
	string temp_feed_name;
	vector <string> feeds_string;
	vector <string> feed_titles;
	vector <string> episodes_string;
	vector <string> episode_titles;
	int i;
	
	while(choice != 7)
	{

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
			feed_nrm_title = perl.add_feed(feed_url, temp_feed_name); //cria diretorio do feed e adiciona no json
	
			new_feed_path = ".feeds/" + feed_nrm_title + "/" + feed_nrm_title + ".xml";

			//
		//move_file_command = "mv " + temp_feed_name + " .feeds/" + feed_nrm_title + "/" + feed_nrm_title + ".xml";
		//	cout<<move_file_command<<endl;
		//	system(move_file_command.c_str());
			
			cout<<temp_feed_name<<endl;
			cout<<new_feed_path<<endl;
			cout<<"could you rename? :"<<rename(temp_feed_name.c_str(), new_feed_path.c_str())<<endl;
		
			break;
		
		case 1: //atualizar feed
			feeds_string = perl.call_perl_function_hash("get_feeds", "./feeds.json");
			i = 2;
			while (i < feeds_string.size())
			{
				feed_titles.push_back(feeds_string[i]);
				i += 3;
			}
			choice = callMenu(feed_titles);
			cout << choice << endl;
			feed_url = feeds_string[choice*3];
			cout << feed_url<<endl;
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
		
		case 2: //baixar episodio
			feeds_string = perl.call_perl_function_hash("get_feeds", "./feeds.json");
			i = 2;
			while (i < feeds_string.size())
			{
				feed_titles.push_back(feeds_string[i]);
				i += 3;
			}
			choice = callMenu(feed_titles);
			feed_name = feed_titles[choice];
			episodes_string = perl.call_perl_function_hash("get_episodes", feed_name);
                    	i = 2;
			while (i < feeds_string.size())
			{
				episode_titles.push_back(episodes_string[i]);
				i += 3;
			}
			choice = callMenu(episode_titles);

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

	choice = callMenu(options);
	
	}
	//cout << input<<endl;
	
	return 0;
}
