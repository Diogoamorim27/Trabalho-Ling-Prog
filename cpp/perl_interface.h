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

		string add_feed(string, string);
		void call_perl_funnction_void(string, string, string, string, string, string);
		vector <string> call_perl_function_hash(string, string);
		string call_perl_function_string(string, string, string, string);
		string normalize_string(string);
		void delete_episode(string, string);

	private:
		PerlInterpreter *my_perl;
		char *my_argv[2];
};
