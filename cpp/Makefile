#g++ -Wall -std=c++11 -I cpr/include/ -L cpr/build/lib/ addFeed.cpp addFeedTest.cpp -lcpr -lcurl -lgtest -lgtest_main -lmongoose -ltest_server -o addFeedTest
CPP = g++
CPPFLAGS = -Wall -std=c++11 -I cpr/include/

LD = g++
LDFLAGS = -Wall -std=c++11

I_CPR = cpr/include/
L_CPR = cpr/build/lib/ -lcpr -lcurl -lgtest -lgtest_main -lmongoose -ltest_server

ADD_FEED_OBJS = addFeedTest.o addFeed.o
#DOWNLOAD_EP_OBJS = downloadEpisodeTest.o downloadEpisode.o
DELETE_EP_OBJS = deleteEpisodeTest.o deleteEpisode.o

EXECS = addFeedTest\
	deleteEpisodeTest
	#downloadEpisodeTest

.cpp.o:
	$(CPP) $(CPPFLAGS) -c $<

all: $(EXECS)

addFeedTest: $(ADD_FEED_OBJS)
	$(LD) $(LDFLAGS) -o $@ $(ADD_FEED_OBJS) -I $(I_CPR) -L $(L_CPR)

#downloadEpisodeTest: $(DOWNLOAD_EP_OBJS)
#	$(LD) $(LDFLAGS) -o $@ $(DOWNLOAD_EP_OBJS) -I $(I_CPR) -L $(L_CPR)

deleteEpisodeTest: $(DELETE_EP_OBJS)
	$(LD) $(LDFLAGS) -o $@ $(DELETE_EP_OBJS) -I $(I_CPR) -L $(L_CPR)

clean:
	rm -f *.o $(EXECS)
