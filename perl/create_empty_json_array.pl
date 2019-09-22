use strict;
use warnings;
use JSON;

sub create_empty_json_array
{
	my $file_name = $_[0];

	my @empty_array;

	my @json_empty_array = to_json \@empty_array;

	if (-e $file_name) {
		system("rm $file_name");
	};

	open(my $fh, ">", "$file_name")
		or die "Can't open < $file_name: $!\n ";

	print $fh @json_empty_array;

	close($fh);
		|| warn "$file_name - close failed: $!\n";

}

1;
