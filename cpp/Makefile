#g++ -Wall -std=c++11 -I cpr/include/ -L cpr/build/lib/ addFeed.cpp addFeedTest.cpp -lcpr -lcurl -lgtest -lgtest_main -lmongoose -ltest_server -o addFeedTest
CPP = g++
CPPFLAGS = -Wall -std=c++11 -O `perl -MExtUtils::Embed -e ccopts -e ldopts` 

LD = g++
LDFLAGS = -Wall -std=c++11

L_CPR = -lcurl -lncursesw `perl -MExtUtils::Embed -e ccopts -e ldopts` 
O_FLAGS = -Wcpp

MAIN_OBJS = main.o downloadFeed.o ui.o perl_interface.o episode.o downloadEpisode.o deleteEpisode.o feed.o deleteFeed.o

EXECS = main
	#addFeedTest\
	#deleteEpisodeTest
	#downloadEpisodeTest

.cpp.o:
	$(CPP) $(CPPFLAGS) -c $<

all: $(EXECS)

#addFeedTest: $(ADD_FEED_OBJS)
#	$(LD) $(LDFLAGS) -o $@ $(ADD_FEED_OBJS) -I $(I_CPR) -L $(L_CPR)

#downloadEpisodeTest: $(DOWNLOAD_EP_OBJS)
#	$(LD) $(LDFLAGS) -o $@ $(DOWNLOAD_EP_OBJS) -I $(I_CPR) -L $(L_CPR)

#deleteEpisodeTest: $(DELETE_EP_OBJS)
#	$(LD) $(LDFLAGS) -o $@ $(DELETE_EP_OBJS) -I $(I_CPR) -L $(L_CPR)
#
main: $(MAIN_OBJS)
	$(LD) $(LDFLAGS) -O $(O_FLAGS) -o $@ $(MAIN_OBJS) $(L_CPR)

clean:
	rm -f *.o $(EXECS)


