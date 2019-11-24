#g++ -Wall -std=c++11 -I cpr/include/ -L cpr/build/lib/ addFeed.cpp addFeedTest.cpp -lcpr -lcurl -lgtest -lgtest_main -lmongoose -ltest_server -o addFeedTest
CPP = g++
CPPFLAGS = -Wall -std=c++11 -I cpr/include/ `perl -MExtUtils::Embed -e ccopts -e ldopts` 

LD = g++
LDFLAGS = -Wall -std=c++11

I_CPR = cpr/include/ 
L_CPR = cpr/build/lib/ -lcpr -lcurl -lgtest -lgtest_main -lmongoose -ltest_server -lncurses `perl -MExtUtils::Embed -e ccopts -e ldopts` 

MAIN_OBJS = main.o downloadFeed.o ui.o perl_interface.o

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
	$(LD) $(LDFLAGS) -o $@ $(MAIN_OBJS) -I $(I_CPR) -L $(L_CPR)

clean:
	rm -f *.o $(EXECS)

 
