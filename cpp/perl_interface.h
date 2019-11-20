#include <iostream>
#include <string>
#include <EXTERN.h>
#include <perl.h>

using namespace std;

class PerlInterface {
	public:
		PerlInterface(string);
		~PerlInterface();
		void interpreter();
		void add_feed(string, string);
		
		HV** get_episodes(string);
		
		/*void add_episode_to_json(string, HV*, string);
		void delete_episode(string, string, string);
		void delete_feed(string, string, string);
		string generate_episode_file_path(string, HV*);
		string normalize_string(string);
		HV** get_dowloaded_episodes_from_feed(string, string);
		HV** get_feeds(string);
		HV** search_episodes(string, string);
                HV **get_new_episodes(string, string)*/

	private:
		PerlInterpreter *my_perl;
		char *my_argv[2];
};
