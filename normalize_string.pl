use strict;
use warnings;
use Text::Unaccent::PurePerl qw(unac_string);

sub normalize_string
{ 
	my $string = $_[0]; 

	my $normalized = unac_string("UTF-8", $string);

	$normalized =~ s/ /_/g;
	$normalized = lc $normalized;

	return $normalized; 
}

1;
