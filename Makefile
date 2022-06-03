CC=cc
AR=ar
OPT=-O2
STD=-std=gnu99
LDFLAGS=-lseccomp
WARNING=-Werror -Wall -Wextra -Wpedantic -Wfloat-equal -Wundef -Wshadow \
		-Wpointer-arith -Wcast-align -Wstrict-prototypes -Wmissing-prototypes \
		-Wstrict-overflow=5 -Wwrite-strings -Waggregate-return -Wcast-qual \
		-Wswitch-enum -Wunreachable-code -Wformat -Wformat -Wformat-security

FLAGS=-fstack-protector-all -fPIC -D_FORTIFY_SOURCE=2 -pipe -fcf-protection
CFLAGS=$(WARNING) $(STD) $(OPT) $(FLAGS)

release: OPT=-O2
release: all

debug: OPT=-O0 -ggdb3
debug: all

.PHONY: all
all: capejail libenableseccomp.so libenableseccomp.a

capejail: libenableseccomp.a main.o
	$(CC) -o capejail main.o libenableseccomp.a $(CFLAGS) $(LDFLAGS)

main.o: main.c enableseccomp.h
	$(CC) -c main.c $(CFLAGS)

enableseccomp.o: enableseccomp.c enableseccomp.h
	$(CC) -c enableseccomp.c $(CFLAGS)

libenableseccomp.so: enableseccomp.o
	$(CC) -shared -o libenableseccomp.so $(CFLAGS) enableseccomp.o

libenableseccomp.a: enableseccomp.o
	$(AR) rcs -o  libenableseccomp.a enableseccomp.o

.PHONY: lint
lint:
	clang-tidy *.c *.h

.PHONY: clean
clean:
	rm -f *.a
	rm -f *.so
	rm -f *.o
	rm -f capejail
