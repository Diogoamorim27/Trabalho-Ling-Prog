#include "../headers/perl_interface.h"
#include <iostream>
#include <string>
#include <perl.h>
#include <EXTERN.h>

int main () {
	PerlInterface interface("");
	interface.interpreter();

	//SV *episode_list_ref = newRV((SV*) pointer);
	//HV* some_episode;

	//episode_list = interface.get_episodes("Waypoint Radio");
	//some_episode = *episode_list[0];

	//cout << *(hv_fetch(some_episode, "title", 502, false));

	return 0;
}
	
