#define _GNU_SOURCE
#include <grp.h>
#include <sched.h>
#include <stdbool.h>
#include <stdio.h>
#include <unistd.h>

#include "logger.h"
#include "privileges.h"

static int do_unshare(bool disable_networking) {
    int err = 0;

    /*
     * Start new processes in a new process ID namespace, this way the user
     * process will not be able to see any other processes on the system other
     * than itself and any child processes that it creates.
     */
    int unshare_flags = CLONE_NEWPID;

    if (disable_networking) {
        unshare_flags |= CLONE_NEWNET;
    }

    err = unshare(unshare_flags);
    if (err) {
        perror("unshare");
        goto done;
    }

done:
    return err;
}

int cape_drop_privileges(uid_t uid, bool disable_networking) {
    /*
     * Drop root privileges:
     * https://wiki.sei.cmu.edu/confluence/display/c/POS36-C.+Observe+correct+revocation+order+while+relinquishing+privileges
     */
    int err = 0;
    gid_t list[1];
    const size_t len = sizeof(list) / sizeof(*list);

    list[0] = uid;

    err = do_unshare(disable_networking);
    if (err) {
        cape_log_error("could not unshare");
        goto done;
    }

    err = setgroups(len, list);
    if (err) {
        perror("setgroups");
        cape_log_error("could not setgroups to: '%d'", uid);
        goto done;
    }

    err = setgid(uid);
    if (err) {
        perror("setgid");
        cape_log_error("could not setgid to: '%d'", uid);
        goto done;
    }

    err = setuid(uid);
    if (err) {
        perror("setuid");
        cape_log_error("could not setuid to: '%d'", uid);
        goto done;
    }

done:
    return err;
}
