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
use Unicode::Collate;

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
                    #                               #                    #                  #                        #                                     #                                                           
my @list=("Adicionar um novo feed", "Adicionar episódio baixado", "Deletar episódio", "Deletar feed", "Gerar nome de arquivo para um episódio", "Exibir episódios baixados", "Procurar novos episódios");
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

    print "\n Feed adicionado com sucesso! \n";

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

    chomp $feed_escolhido;

    @list = ("Procurar episódio", "Listar episódios");
    $banner = "Selecione a maneira de escolher o episódio:";
    $selection=&pick(\@list,$banner);

    chomp $selection;

    my $episode_data;
    my @episodes;
    my @episode_names;

    if ($selection eq "Listar episódios") {

        #print Dumper(get_episodes($feed_escolhido));

        @episodes = get_episodes($feed_escolhido);
        
        foreach $i (@episodes) {
            push @episode_names, ${$i}{'title'};
        }
        
        @list = @episode_names;
        $banner="   Escolha o episodio a ser adicionado";
        $selection=&pick(\@list,$banner);

        chomp $selection;

        foreach $i (@episodes) {
            if (${$i}{'title'} eq $selection) {
                $episode_data = \%{$i};
            }
        }

        
      #  $feed_escolhido = ${$selection}{"title"};
    }

    elsif ($selection eq "Procurar episódio") {
        my $termo_buscado = <>;

        @episodes = search_episodes($feed_escolhido, $termo_buscado);
        
        foreach $i (@episodes) {
            push @episode_names, ${$i}{'title'};
        }
        
        @list = @episode_names;
        $banner="   Escolha o episodio a ser adicionado";
        $selection=&pick(\@list,$banner);

        chomp $selection;

        foreach $i (@episodes) {
            if (${$i}{'title'} eq $selection) {
                $episode_data = \%{$i};
            }
        }
    }

    add_episode_to_json($feed_escolhido, $episode_data, "episodes.json" );

    print "\n Episódio adicionado com sucesso! \n";
}

if ($selection eq "Exibir episódios baixados") {
    my @feeds = get_feeds("feeds.json");
    my @feed_names;
    my $i;
    foreach $i (@feeds) {
        push @feed_names, ${$i}{"title"};
    }
    
    my $episodes;

    @list = @feed_names;
    $banner="   Escolha o feed para exibir";
    $selection=&pick(\@list,$banner);
    my $feed_escolhido = $selection;

    chomp $feed_escolhido;

    $episodes= get_downloaded_episodes_from_feed($feed_escolhido, "episodes.json");
    
    #print Dumper (@episodes);

    my @episode_names;

    foreach $i (@{$episodes}) {
            push @episode_names, ${$i}{'title'};
        }

    foreach $i (@episode_names) {
        print "\n $i \n";
    }

    print "\n";

}

if ($selection eq "Deletar episódio") {
    my @feeds = get_feeds("feeds.json");
    my @feed_names;
    my $i;
    foreach $i (@feeds) {
        push @feed_names, ${$i}{"title"};
    }
    
    my $episodes;

    @list = @feed_names;
    $banner="   Escolha feed do qual deletar";
    $selection=&pick(\@list,$banner);
    my $feed_escolhido = $selection;

    chomp $feed_escolhido;

    $episodes= get_downloaded_episodes_from_feed($feed_escolhido, "episodes.json");
    
    #print Dumper (@episodes);

    my @episode_names;

    foreach $i (@{$episodes}) {
            push @episode_names, ${$i}{'title'};
    }

    @list = @episode_names;
    $banner="   Escolha escolha episódio para deletar";
    $selection=&pick(\@list,$banner);

    chomp $selection;

    delete_episode($feed_escolhido, $selection, "episodes.json");

    print "\n Episódio deletado! \n";

}

if ($selection eq "Deletar feed") {
    my @feeds = get_feeds("feeds.json");
    my @feed_names;
    my $i;
    foreach $i (@feeds) {
        push @feed_names, ${$i}{"title"};
    }
    
    my $episodes;

    @list = @feed_names;
    $banner="   Escolha feed do qual deletar";
    $selection=&pick(\@list,$banner);
    my $feed_escolhido = $selection;

    chomp $feed_escolhido;

    delete_feed($feed_escolhido, "episodes.json", "feeds.json");

    print "Feed deletado com sucesso!\n";

}

if ($selection eq "Gerar nome de arquivo para um episódio") {
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

    chomp $feed_escolhido;

    @list = ("Procurar episódio", "Listar episódios");
    $banner = "Selecione a maneira de escolher o episódio:";
    $selection=&pick(\@list,$banner);

    chomp $selection;

    my $episode_data;
    my @episodes;
    my @episode_names;

    if ($selection eq "Listar episódios") {

        #print Dumper(get_episodes($feed_escolhido));

        @episodes = get_episodes($feed_escolhido);
        
        foreach $i (@episodes) {
            push @episode_names, ${$i}{'title'};
        }
        
        @list = @episode_names;
        $banner="   Escolha o episodio";
        $selection=&pick(\@list,$banner);

        chomp $selection;

        foreach $i (@episodes) {
            if (${$i}{'title'} eq $selection) {
                $episode_data = \%{$i};
            }
        }

        
      #  $feed_escolhido = ${$selection}{"title"};
    }

    elsif ($selection eq "Procurar episódio") {
        my $termo_buscado = <>;

        @episodes = search_episodes($feed_escolhido, $termo_buscado);
        
        foreach $i (@episodes) {
            push @episode_names, ${$i}{'title'};
        }
        
        @list = @episode_names;
        $banner="   Escolha o episodio";
        $selection=&pick(\@list,$banner);

        chomp $selection;

        foreach $i (@episodes) {
            if (${$i}{'title'} eq $selection) {
                $episode_data = \%{$i};
            }
        }
    }

    print generate_episode_file_path($feed_escolhido, $episode_data);

    print "\n \n";
}

if ($selection eq "Procurar novos episódios") {
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

    chomp $feed_escolhido;

    my $novos_episodios;

    $novos_episodios = get_new_episodes($feed_escolhido, "episodes.json");

    my @episode_names;

    foreach $i (@{$novos_episodios}) {
            push @episode_names, ${$i}{'title'};
        }

    foreach $i (@episode_names) {
        print "\n $i \n";
    }
}
