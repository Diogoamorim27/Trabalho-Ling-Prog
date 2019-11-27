#include <iostream>
#include <string>
#include <vector>
#include <EXTERN.h>
#include <perl.h>

using namespace std;

class PerlInterface {
	public:
		PerlInterface(string);
		~PerlInterface();
		void interpreter();

		vector <string> call_perl_function_hash(string, string);
		vector <string> search_episodes(string, string);

		string call_perl_function_string(string, string, string, string);
		string add_feed(string, string);
		string normalize_string(string);

		void delete_episode(string, string);
		void delete_feed(string);
		void call_perl_function_void(string, string, string, string);
	private:
		PerlInterpreter *my_perl;
		char *my_argv[2];
};
