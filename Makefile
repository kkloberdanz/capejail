CC=cc
OPT=-O2
STD=-std=c89
LDFLAGS=-lseccomp
WARNING=-Werror -Wall -Wextra -Wpedantic -Wfloat-equal -Wundef -Wshadow \
	-Wpointer-arith -Wcast-align -Wstrict-prototypes -Wmissing-prototypes \
	-Wstrict-overflow=5 -Wwrite-strings -Waggregate-return -Wcast-qual \
	-Wswitch-enum -Wunreachable-code -Wformat -Wformat-security -Wvla \

FLAGS=-fPIE -pipe -fharden-compares
CFLAGS=$(WARNING) $(STD) $(OPT) $(FLAGS)

SRC = $(wildcard *.c)
HEADERS = $(wildcard *.h)
OBJS = $(patsubst %.c,%.o,$(SRC))

.PHONY: release
release: OPT=-O2 -fhardened
release: all

.PHONY: debug
debug: OPT=-O0 -ggdb3
debug: all

.PHONY: sanitize
sanitize: OPT=-O0 -ggdb3 -fsanitize=address,undefined,leak
sanitize: all

.PHONY: all
all: capejail

capejail: $(OBJS)
	$(CC) -o capejail $(OBJS) $(CFLAGS) $(LDFLAGS)

%.o: %.c
	$(CC) -c $< -o $@ $(CFLAGS)

.PHONY: lint
lint:
	clang-tidy *.c *.h

.PHONY: fmt
fmt:
	clang-format -i *.c *.h

deps.mk: $(SRC) $(HEADERS)
	$(CC) -MM $(SRC) $(INC) > deps.mk

include deps.mk

.PHONY: clean
clean:
	rm -f *.a
	rm -f *.so
	rm -f *.o
	rm -f capejail
