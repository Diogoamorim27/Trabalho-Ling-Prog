#include <EXTERN.h>
#include <perl.h>

static PerlInterpreter *my_perl;

static void

PerlPower(char *url, char *tmpFilePath)
{
	dSP;                            /* initialize stack pointer      */
	ENTER;                          /* everything created after here */
	SAVETMPS;                       /* ...is a temporary variable.   */
	PUSHMARK(SP);                   /* remember the stack pointer    */
	XPUSHs(sv_2mortal(newSVpv(url))); /* push the base onto the stack  */
	XPUSHs(sv_2mortal(newSVpv(tmpFilePath))); /* push the exponent onto stack  */
	PUTBACK;                      /* make local stack pointer global */
	call_pv("add_feed", G_SCALAR);      /* call the function             */
	SPAGAIN;                        /* refresh stack pointer         */
				     /* pop the return value from stack */
	printf ("url:%s, tmpFilePath:%s\n", url, tmpFilePath);
	PUTBACK;
	FREETMPS;                       /* free that return value        */
	LEAVE;                       /* ...and the XPUSHed "mortal" args.*/
}

int main (int argc, char **argv, char **env)
{
	char *url = "waypoint.com";
	char *tmpFilePath =  "waypoint.xml";
	char *my_argv[] = { "", "module.pl", NULL };
	PERL_SYS_INIT3(&argc,&argv,&env);
	my_perl = perl_alloc();
	perl_construct( my_perl );
	perl_parse(my_perl, NULL, 2, my_argv, (char **)NULL);
	PL_exit_flags |= PERL_EXIT_DESTRUCT_END;
	perl_run(my_perl);
	PerlPower(url, tmpFilePath);                      /*** Compute 3 ** 4 ***/
	perl_destruct(my_perl);
	perl_free(my_perl);
	PERL_SYS_TERM();
	exit(EXIT_SUCCESS);
}
