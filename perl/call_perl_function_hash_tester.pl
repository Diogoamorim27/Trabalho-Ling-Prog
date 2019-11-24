require "./perl/call_perl_function_hash.pl";

my @strings;

@strings = call_perl_function_hash("get_feeds", "feeds.json");

for my $i (0 .. $#strings)
{
    print "$strings[$i]\n";
}
