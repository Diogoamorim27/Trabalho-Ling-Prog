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

	private:
		PerlInterpreter *my_perl;
		char *my_argv[2];
};
