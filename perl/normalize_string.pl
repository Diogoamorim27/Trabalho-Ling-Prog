use strict;
use warnings;
use Text::Unaccent::PurePerl qw(unac_string);
use Encode qw( encode_utf8 );
use utf8;
use open qw(:std :encoding(UTF-8));

sub normalize_string
{ 
	my $string = $_[0]; 

	my $normalized = unac_string("UTF-8", encode_utf8($string));

	$normalized =~ s/ /_/g;
	$normalized = lc $normalized;

	return $normalized; 
}

1;
