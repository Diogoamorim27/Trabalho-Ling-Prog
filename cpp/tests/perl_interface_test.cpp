#include "../headers/perl_interface.h"
#include <iostream>
#include <string>

int main () {
	PerlInterface interface("");
	interface.interpreter();

	interface.add_feed("waypoint.com", "waypoint_radio.xml");
	return 0;
}
	
