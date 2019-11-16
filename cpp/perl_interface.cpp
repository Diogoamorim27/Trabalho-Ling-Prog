#include <stddef.h>
#include <string>
#include "headers/perl_interface.h"

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


PerlInterface::PerlInterface(string script = "oi") {
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

void PerlInterface::add_feed(string url, string feed_xml) {
	dSP;
	ENTER;
	SAVETMPS;
	PUSHMARK(SP);

	XPUSHs(sv_2mortal(newSVpv(url.c_str(),url.length())));
	XPUSHs(sv_2mortal(newSVpv(feed_xml.c_str(),feed_xml.length())));

	PUTBACK;

	call_pv("add_feed", G_DISCARD);

	SPAGAIN; //como a função é void tvz não seja necessário

	PUTBACK;
	FREETMPS;
	LEAVE;
}
