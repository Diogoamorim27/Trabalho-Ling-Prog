use strict;
use warnings;

sub get_feeds
{
    my $file_path = "feeds.json";

    open (my $fh, "<", $file_path)
        or die "Can't open $file_path: $!\n";

    my $json = "";

    while (my $reader = <$fh>)
    {
        $json = $json.$reader;
    }

    my @feeds;
    my @feeds_data_raw;

    ($feeds_data_raw[0]) = $json =~ /{(.*)}/s;
    (@feeds_data_raw) = $feeds_data_raw[0] =~ /{(.*?)}/gs;

    foreach my $feed (@feeds_data_raw)
    {
        my %feed_data;
        ($feed_data{url}) = $feed =~ /"url":\s+"(.*?)",/;
        ($feed_data{title}) = $feed =~ /"title":\s+"(.*?)",/;
        ($feed_data{language}) = $feed =~ /"language":\s+"(.*?)"/;
        unshift @feeds, \%feed_data;
    }

    close($fh)
        or warn "$file_path - close failed: $!\n";

    return @feeds;
}

#test program

#my @feeds = get_feeds();

#for my $i (0 .. $#feeds)
#{
#    for my $attribute (keys %{$feeds[$i]})
#    {
#        print "$feeds[$i]{$attribute}\n";
#    }
#}
