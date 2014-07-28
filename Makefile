.PHONY : all win clean

all : sproto.so
win : sproto.dll

sproto.so : sproto.c lsproto.c
	gcc -O2 -Wall -fPIC --shared $@ $^

sproto.dll : sproto.c lsproto.c
	gcc -g -Wall --shared -o $@ $^ -I/usr/local/include -L/usr/local/bin -llua52

clean :
	rm -f sproto.so sproto.dll
