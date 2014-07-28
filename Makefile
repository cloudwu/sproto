.PHONY : all clean

all : sproto.so

sproto.so : sproto.c lsproto.c
	gcc -O2 -Wall -fPIC --shared -o $@ $^

clean :
	rm -f sproto.so
