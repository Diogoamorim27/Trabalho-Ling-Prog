#include <stddef.h>
#include <string>
#include <vector>
#include "perl_interface.h"

static void xs_init (pTHX);
EXTERN_C void boot_DynaLoader (pTHX_ CV* cv);
EXTERN_C void boot_Socket (pTHX_ CV* cv);
void
xs_init(pTHX)
{
    	char *file = __FILE__;
    /* DynaLoader is a special case */
	dXSUB_SYS;
	PERL_UNUSED_CONTEXT;
   	
	newXS("DynaLoader::boot_DynaLoader", boot_DynaLoader, file);
    
    //newXS("Socket::bootstrap", boot_Socket, file);
}


PerlInterface::PerlInterface(string script = "") {
	int dummy_argc = 0;
	char*** dummy_env = 0;
	char string[] = {};
	char* dummy_argv[]= {string, &script[0]};

	PERL_SYS_INIT3(&dummy_argc, dummy_env, dummy_env);

	my_perl = perl_alloc();
	perl_construct(my_perl);
	PL_exit_flags |= PERL_EXIT_DESTRUCT_END;
}

PerlInterface::~PerlInterface() {
	perl_destruct(my_perl);
	perl_free(my_perl);

	PERL_SYS_TERM();
}

void PerlInterface::interpreter() {
	char _MYARGV_PERL_MODULE_NAME[] = "perl/interface.pl";
	char _MYARGV_NOTHING_NAME[] = "";
	char *my_argv[] = {static_cast<char*>(_MYARGV_NOTHING_NAME), static_cast<char*>(_MYARGV_PERL_MODULE_NAME)};

	perl_parse(my_perl, xs_init, 2, my_argv, NULL);
	perl_run(my_perl);
}

string PerlInterface::add_feed(string url, string feed_xml) {
	dSP;
	ENTER;
	SAVETMPS;
	PUSHMARK(SP);

	string normalized_title;

	XPUSHs(sv_2mortal(newSVpv(url.c_str(),url.length())));
	XPUSHs(sv_2mortal(newSVpv(feed_xml.c_str(),feed_xml.length())));

	PUTBACK;

	call_pv("add_feed", G_SCALAR);

	SPAGAIN;

	SV *sv = POPs;
	normalized_title = SvPV_nolen(sv);

	PUTBACK;
	FREETMPS;
	LEAVE;

	return normalized_title;
}

void PerlInterface::call_perl_function_void(string feed, string title, string date, string url){
	dSP;
	ENTER;
	SAVETMPS;
	PUSHMARK(SP);

	string eps = "./episodes.json";
	string function = "add_episode_to_json";
	
	XPUSHs(sv_2mortal(newSVpv(function.c_str(),function.length())));
	XPUSHs(sv_2mortal(newSVpv(feed.c_str(),feed.length())));
	XPUSHs(sv_2mortal(newSVpv(eps.c_str(),eps.length())));
	XPUSHs(sv_2mortal(newSVpv(title.c_str(),title.length())));
	XPUSHs(sv_2mortal(newSVpv(date.c_str(),date.length())));
	XPUSHs(sv_2mortal(newSVpv(url.c_str(),url.length())));

	PUTBACK;

	call_pv("call_perl_function_void", G_DISCARD);
	
	FREETMPS;
	LEAVE;

};

string PerlInterface::normalize_string(string str) {
	dSP;
	ENTER;
	SAVETMPS;
	PUSHMARK(SP);

	string return_str;

	XPUSHs(sv_2mortal(newSVpv(str.c_str(),str.length())));

	PUTBACK;

	call_pv("normalize_string", G_SCALAR);

	SPAGAIN;
	
	SV *sv = POPs;
	return_str = SvPV_nolen(sv);

	FREETMPS;
	LEAVE;

	return return_str;

}

vector <string> PerlInterface::call_perl_function_hash(string function, string feed_name){
	dSP;	
	int i;
	int count;
	vector <string> func_return;
	
	ENTER;
	SAVETMPS;
	PUSHMARK(SP);

	XPUSHs(sv_2mortal(newSVpv(function.c_str(),function.length())));
	XPUSHs(sv_2mortal(newSVpv(feed_name.c_str(),feed_name.length())));

	PUTBACK;

	count = call_pv("call_perl_function_hash", G_ARRAY);

	SPAGAIN;
	
	SV *sv;
	for (i=0;i<count;i++) {
		sv = POPs;
		func_return.push_back(SvPV_nolen(sv));
	}
	FREETMPS;
	LEAVE;

	return func_return;
}
		
string PerlInterface::call_perl_function_string(string func, string feed_name, string ep_title, string ep_url){
	dSP;
	ENTER;
	SAVETMPS;
	PUSHMARK(SP);

	string return_str;

	XPUSHs(sv_2mortal(newSVpv(func.c_str(),func.length())));
	XPUSHs(sv_2mortal(newSVpv(feed_name.c_str(),feed_name.length())));
	XPUSHs(sv_2mortal(newSVpv(ep_title.c_str(),ep_title.length())));
	XPUSHs(sv_2mortal(newSVpv(ep_url.c_str(),ep_url.length())));

	PUTBACK;

	call_pv("call_perl_function_string", G_SCALAR);

	SPAGAIN;
	
	SV *sv = POPs;
	return_str = SvPV_nolen(sv);

	FREETMPS;
	LEAVE;

	return return_str;


}


void PerlInterface::delete_episode(string feed_name, string episode_name) {
	dSP;
	ENTER;
	SAVETMPS;
	PUSHMARK(SP);

	string eps = "./episodes.json";

	XPUSHs(sv_2mortal(newSVpv(feed_name.c_str(),feed_name.length())));
	XPUSHs(sv_2mortal(newSVpv(episode_name.c_str(),episode_name.length())));
	XPUSHs(sv_2mortal(newSVpv(eps.c_str(),eps.length())));

	PUTBACK;

	call_pv("delete_episode", G_DISCARD);

	SPAGAIN;
	
	FREETMPS;
	LEAVE;
}

void PerlInterface::delete_feed(string feed) {
	dSP;
	ENTER;
	SAVETMPS;
	PUSHMARK(SP);

	string eps = "./episodes.json";
	string feeds = "./feeds.json";

	XPUSHs(sv_2mortal(newSVpv(feed.c_str(),feed.length())));
	XPUSHs(sv_2mortal(newSVpv(eps.c_str(),eps.length())));
	XPUSHs(sv_2mortal(newSVpv(feeds.c_str(),feeds.length())));

	PUTBACK;

	call_pv("delete_feed", G_DISCARD);

	SPAGAIN;
	
	FREETMPS;
	LEAVE;

}
