.PHONY : all win clean

CC = gcc
COPT = -g -Wall

all : sproto.so
win : sproto.dll

FILES = sproto.o lsproto.o

# For Linux
linux:
	make sproto.so "DLLFLAGS = -shared -fPIC"

# For Mac OS
macosx:
	make sproto.so "DLLFLAGS = -bundle -undefined dynamic_lookup"

sproto.so : $(FILES)
	env ${CC} $(COPT) $(DLLFLAGS) -o $@ $^

sproto.dll : sproto.c lsproto.c
	gcc -O2 -Wall --shared -o $@ $^ -I/usr/local/include -L/usr/local/bin -llua52

clean :
	rm -f sproto.so sproto.dll
