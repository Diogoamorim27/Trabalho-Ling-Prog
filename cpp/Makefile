#g++ -Wall -std=c++11 -I cpr/include/ -L cpr/build/lib/ addFeed.cpp addFeedTest.cpp -lcpr -lcurl -lgtest -lgtest_main -lmongoose -ltest_server -o addFeedTest
CPP=g++
CPPFLAGS=-Wall -std=c++11 -I cpr/include/

LD=g++
LDFLAGS=-Wall -std=c++11

ADD_FEED_OBJS = addFeedTest.o addFeed.o

EXECS = addFeedTest

.cpp.o:
	$(CPP) $(CPPFLAGS) -c $<

all: $(EXECS)

addFeedTest: $(ADD_FEED_OBJS)
	$(LD) $(LDFLAGS) -o $@ $(ADD_FEED_OBJS) -I cpr/include/ -L cpr/build/lib/ -lcpr -lcurl -lgtest -lgtest_main -lmongoose -ltest_server

clean:
	rm -f *.o $(EXECS)
