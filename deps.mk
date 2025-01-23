env.o: env.c banned.h env.h vec.h logger.h
launch.o: launch.c banned.h launch.h vec.h logger.h
logger.o: logger.c banned.h logger.h
main.o: main.c banned.h env.h vec.h launch.h logger.h opts.h privileges.h \
 seccomp.h
opts.o: opts.c banned.h logger.h opts.h vec.h
privileges.o: privileges.c logger.h privileges.h
seccomp.o: seccomp.c banned.h logger.h seccomp.h
vec.o: vec.c banned.h vec.h
