use strict;
use warnings;
use JSON;
use File::Slurper;
use Data::Dumper; #debugging
use utf8;
use open qw(:std :encoding(UTF-8));
use Encode qw( encode_utf8 );
use Text::Unaccent::PurePerl;
use Term::Menus;
use podcastUtils;

#my %episode_data = (
   # "title" => "Decrépitos 232 - Leiturão da Massa 2",
  #  "date" => "Mon, 16 Oct 2020 17:30:00 -0300",
 #   "url" => "https://media.blubrry.com/decrepitos/decrepitos.com/podcast/2019/decrepitos_232_leiturao02.mp3"
#);

#add_feed("https://decrepitos.com/podcast/feed.xml", "decrepitos.xml");
#add_episode_to_json("Decrépitos", \%episode_data, "episodes.json");


# exemplo #
#my @list=`ls -1 ./ | grep xml`;
#my $banner="   Please Pick an Item:";
#my $selection=&pick(\@list,$banner);
#print "SELECTION = $selection\n";

# tela inicial #

my @list=("Adicionar um novo feed", "Adicionar episódio baixado", "Deletar episódio", "Deletar feed", "Gerar nome de arquivo para um episódio", "Exibir episódios baixados", "Mostrar episódios de um feed", "Mostrar feeds", "Procurar por episódios", "Procurar novos episódios");
my $banner="   Escolha uma ação para realizar:";
my $selection=&pick(\@list,$banner);

if ($selection eq "Adicionar um novo feed") {
    @list=`ls -1 ./ | grep xml`;
    $banner="   Escolha um feed para adicionar:";
    $selection=&pick(\@list,$banner);

    print Dumper ($selection);

    chomp $selection;

    if ($selection eq 'decrepitos.xml') {
        print "igual!";
    }
    
    my $url = "URL";
    add_feed($url, $selection);

}

if ($selection eq "Adicionar episódio baixado") {
    my @feeds = get_feeds("feeds.json");
    my @feed_names;
    my $i;
    foreach $i (@feeds) {
        push @feed_names, ${$i}{"title"};
    }
    
    @list = @feed_names;
    $banner="   Escolha o feed ao qual o episodio pertence:";
    $selection=&pick(\@list,$banner);
    my $feed_escolhido = $selection;

    @list = ("Procurar episódio", "Listar episódios");
    $banner = "Selecione a maneira de escolher o episódio:";
    $selection=&pick(\@list,$banner);

    #if ($selection)

}

sub normalize_string
{ 
	my $string = $_[0]; 

	my $normalized = unac_string("UTF-8", encode_utf8($string));

	$normalized =~ s/ /_/g;
	$normalized = lc $normalized;

	return $normalized; 
}