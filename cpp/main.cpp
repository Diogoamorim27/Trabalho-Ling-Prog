#include <string>
#include <ncurses.h>
#include <iostream>
#include <cstdlib>
#include <EXTERN.h>
#include <perl.h>
#include <vector>
#include <stdexcept>
#include <fstream>
#include <cstdio>

#include "perl_interface.h"
#include "downloadFeed.h"
#include "vector2.h"
#include "ui.h"
#include "episode.h"
#include "feed.h"
#include "downloadEpisode.h"
#include "deleteEpisode.h"
#include "deleteFeed.h"

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
	string episode_file_path;
	vector <string> feeds_string;
	vector <string> feed_titles;
	vector <string> episodes_string;
	vector <string> episode_titles;
	unsigned i;

	Episode ep_dl("","","","");
	Feed feed_dl("","","");
	
	while(choice != 7)
	{
		feed_titles.clear();
		feeds_string.clear();
		episodes_string.clear();
		episode_titles.clear();
		feed_nrm_title = "";

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

			if (rename(temp_feed_name.c_str(), new_feed_path.c_str()))
				showError("Não foi possível adicionar o feed");
		
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
			if (choice == -1)
			{
				showError("Não há feeds disponíveis");
				break;
			}

			feed_url = feeds_string[choice*3];
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

			if (rename(temp_feed_name.c_str(), new_feed_path.c_str()))
				showError("Não foi possível adicionar o feed");
		
			break;
		
		case 2: //baixar episodio
			feeds_string = perl.call_perl_function_hash("get_feeds", "./feeds.json");
			i = 2;
			while (i < feeds_string.size())
			{
				feed_titles.push_back(feeds_string[i]);
				i += 3;
			}
			if (feed_titles.empty())
				break;
			choice = callMenu(feed_titles);
			if (choice == -1)
			{
				showError("Não há feeds disponíveis");
				break;
			}
feed_name = feed_titles[choice];
			episodes_string = perl.call_perl_function_hash("get_episodes", feed_name);

			i = 2;
			while (i < episodes_string.size())
			{
				episode_titles.push_back(episodes_string[i]);
				i += 3;
			}
			if (episode_titles.empty())
				break;
			choice = callMenu(episode_titles);
			if (choice == -1)
			{
				showError("Não há episódios disponíveis");
				break;
			}
			ep_dl.setTitle(episode_titles[choice]);
			ep_dl.setUrl(episodes_string[choice*3]);
			ep_dl.setDate(episodes_string[choice*3 + 1]);
			ep_dl.setFeedTitle(feed_name);
		       	
			episode_file_path = perl.call_perl_function_string("generate_episode_file_path", feed_name, ep_dl.getTitle(), ep_dl.getUrl());

			downloadEpisode(ep_dl, episode_file_path);
	
			perl.call_perl_function_void(ep_dl.getFeedTitle(), ep_dl.getTitle(), ep_dl.getDate(), ep_dl.getUrl());	

			break;
		
		case 3: //Deletar episódio
			feeds_string = perl.call_perl_function_hash("get_feeds", "./feeds.json");
			i = 2;
			while (i < feeds_string.size())
			{
				feed_titles.push_back(feeds_string[i]);
				i += 3;
			}
			if (feed_titles.empty())
				break;
			choice = callMenu(feed_titles);
feed_name = feed_titles[choice];
			episodes_string = perl.call_perl_function_hash("get_downloaded_episodes_from_feed", feed_name);

			i = 2;
			while (i < episodes_string.size())
			{
				episode_titles.push_back(episodes_string[i]);
				i += 3;
			}
	
			if (episode_titles.empty())
				break;
				
			choice = callMenu(episode_titles);
ep_dl.setTitle(episode_titles[choice]);
			ep_dl.setUrl(episodes_string[choice*3]);
			ep_dl.setDate(episodes_string[choice*3 + 1]);
			ep_dl.setFeedTitle(feed_name);
		       	
			episode_file_path = perl.call_perl_function_string("generate_episode_file_path", feed_name, ep_dl.getTitle(), ep_dl.getUrl());

			deleteEpisode(ep_dl, episode_file_path);
			
			perl.delete_episode(feed_name, ep_dl.getTitle());
			break;
		
		case 4:
			feeds_string = perl.call_perl_function_hash("get_feeds", "./feeds.json");
			
			i = 2;
			while (i < feeds_string.size())
			{
				feed_titles.push_back(feeds_string[i]);
				i += 3;
			}
			choice = callMenu(feed_titles);
			if (choice == -1)
			{
				showError("Não há feeds disponíveis");
				break;
			}
			
			feed_dl.setTitle(feed_titles[choice]);
			feed_dl.setUrl(feeds_string[choice*3]);
			feed_dl.setLanguage(feeds_string[choice*3 + 1]);
	
			feed_nrm_title = perl.normalize_string(feed_dl.getTitle());
			
			deleteFeed(feed_dl, feed_nrm_title);

			perl.delete_feed(feed_dl.getTitle());
		
			break;

		break;
		
		case 5:
		
		break;
		
		case 6:
		break;
		default:
		break;
	}

	choice = callMenu(options);

	}
	//cout << input<<endl;
	
	return 0;
}
