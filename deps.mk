env.o: env.c env.h vec.h logger.h
launch.o: launch.c launch.h vec.h logger.h
logger.o: logger.c logger.h
main.o: main.c env.h vec.h launch.h logger.h opts.h privileges.h \
 seccomp.h
opts.o: opts.c logger.h opts.h vec.h
privileges.o: privileges.c logger.h privileges.h
seccomp.o: seccomp.c logger.h seccomp.h
vec.o: vec.c vec.h
