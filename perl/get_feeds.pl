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

    my @feeds;  #cria array de hashes de feeds
    my @feeds_data_raw;

    ($feeds_data_raw[0]) = $json =~ /\Q[\E(.*)\Q]\E/s  #guarda tudo que ta entre o primeiro e ultimo colchete na primeira posicao do array
        or die "Corrupted JSON file: feeds.json.\n";
    (@feeds_data_raw) = $feeds_data_raw[0] =~ /{(.*?)}/gs;  #percorre a string na primeira posicao e, para cada par "{}", pega o que ha dentro e guarda numa posicao do array

    foreach my $feed (@feeds_data_raw)
    {
        my %feed_data;
        ($feed_data{url}) = $feed =~ /"url"\s+:\s+"(.*?)"[,\n]/;   #$feed_data{url} recebe o que esta entre "\"url\":\"" e "\"[,\n]" ignorando espacos em branco (\s+)
        ($feed_data{title}) = $feed =~ /"title"\s+:\s+"(.*?)"[,\n]/;
        ($feed_data{language}) = $feed =~ /"language"\s+:\s+"(.*?)"[,\n]/;
        unshift @feeds, \%feed_data;    #guarda o hash do feed na primeira posicao de @feeds, deslocando os outros elementos para a direita
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
