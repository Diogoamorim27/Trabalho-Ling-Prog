CPP = g++
CPPFLAGS = -Wall -std=c++11 -O `perl -MExtUtils::Embed -e ccopts -e ldopts` 

LD = g++
LDFLAGS = -Wall -std=c++11

L_CPR = -lcurl -lncursesw `perl -MExtUtils::Embed -e ccopts -e ldopts` 
O_FLAGS = -Wcpp

MAIN_OBJS = cpp/main.o cpp/downloadFeed.o cpp/ui.o cpp/perl_interface.o cpp/episode.o cpp/downloadEpisode.o cpp/deleteEpisode.o cpp/feed.o cpp/deleteFeed.o cpp/playEpisode.o

EXECS = main
	#addFeedTest\
	#deleteEpisodeTest
	#downloadEpisodeTest

.cpp.o:
	$(CPP) $(CPPFLAGS) -c $<

all: $(EXECS)

main: $(MAIN_OBJS)
	$(LD) $(LDFLAGS) -O $(O_FLAGS) -o $@ $(MAIN_OBJS) $(L_CPR)

clean:
	rm -f *.o $(EXECS)


