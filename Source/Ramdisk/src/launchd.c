/**
 * launchd.c - Part of Ac1dSn0w
 * Copyright (C) 2011 Manuel Gebele (forensix)
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 **/

#include <sys/stat.h>
#include <sys/wait.h>

#include "launchd.h"
#include "hfs_mount.h"
#include "syscalls.h"
#include "utils.h"
#include "ld_error.h"
#include "ld_debug.h"

int init_console() {
	console = open(CONS_DEV_PATH, O_WRONLY);
	dup2(console, 1);
	dup2(console, 2);
}

int mnt_rootfs() {
    return hfs_mount(ROOT_DEV_PATH, ROOT_MNT_PATH, 0);
}

int mnt_userfs() {
    return hfs_mount(USER_DEV_PATH, USER_MNT_PATH, 0);
}

int prepare_fs() {
    int retval = 0;
    
    retval = mnt_rootfs();
    if (retval)
        return 1;
    
    return 0; //mnt_userfs();
}

void create_ac1dismygift_dir() {
    mkdir(DESTINATION_DIR, 0755);
}

int install_binaries() {
    int retval = 0;
    
    /*
     * bash, gzip, rm, tar
     */
    retval = install(bash[0], bash[1], 0, 0, 0755);
    if (retval)
        return 1;
    
    retval = install(gzip[0], gzip[1], 0, 0, 0755);
    if (retval)
        return 1;
    
    retval = install(rm[0], rm[1], 0, 0, 0755);
    if (retval)
        return 1;
    
    return install(tar[0], tar[1], 0, 0, 0755);
}

int install_patches() {
    int retval = 0;
    
    /*
     * com.apple.mobile.installation.plist, fstab, K48AP.plist
     */
    retval = install(cydia_patch[0], cydia_patch[1], 0, 0, 0755);
    if (retval)
        return 1;
    
    retval = cp(fstab[0], fstab[1]);
    if (retval)
        return 1;
    
    return cp(ipad_patch[0], ipad_patch[1]);
}

int install_libraries() {
    int retval = 0;
    
    /*
     * libgcc, libhistory, libiconv,
     * libncurses, libreadline, libsystem
     */
    retval = install(libgcc[0], libgcc[1], 0, 80, 0755);
    if (retval)
        return 1;
    
    retval = install(libhistory[0], libhistory[1], 0, 80, 0755);
    if (retval)
        return 1;
    
    retval = install(libiconv[0], libiconv[1], 0, 80, 0755);
    if (retval)
        return 1;
    
    retval = install(libncurses[0], libncurses[1], 0, 80, 0755);
    if (retval)
        return 1;
    
    retval = install(libreadline[0], libreadline[1], 0, 80, 0755);
    if (retval)
        return 1;
    
    return install(libsystem[0], libsystem[1], 0, 80, 0755);
}

/* /System/Library/LaunchDaemons/ */
int install_launchd() {
    int retval = 0;
    
    /*
     * ac1dismygift.plist, ac1ddrop
     */
    retval = install(ld_plist[0], ld_plist[1], 0, 0, 0755);
    if (retval)
        return 1;
    
    return install(ac1ddrop[0], ac1ddrop[1], 0, 0, 0755);
}

int install_cydia() {    
    /*
     * Cydia.tar.gz
     */
    return install(cydia[0], cydia[1], 0, 0, 0755);
}

int install_payload() {
    int retval = 0;
    
    create_ac1dismygift_dir();
    
    retval = install_binaries();
    if (retval)
        return 1;
    
    retval = install_patches();
    if (retval)
        return 1;
    
    retval = install_libraries();
    if (retval)
        return 1;
    
    retval = install_launchd();
    if (retval)
        return 1;
    
    return install_cydia();
}

void cleanup() {
    unmount(ROOT_MNT_PATH, 0);
    unmount(USER_MNT_PATH, 0);
    close(console);
}

int main(int argc, char **argv) {
    struct stat st;
    int retval = 0;
    int fail = -1;
    
    init_console();
    
    ld_debug_waiting_for_disk();
    while (stat(DISK_DEV_PATH, &st) != 0) {
        ld_debug_waiting_for_disk();
        sleep(1);
    }
    
    // NOTE: fsck_hfs is done in final version.
    
    ld_debug_mount_fs();
    retval = prepare_fs();
    if (retval) {
        ld_error_unable_to_mount_fs();
        cleanup();
        return fail;
    }
    
    ld_debug_upload_payload();
    retval = install_payload();
    if (retval) {
        ld_error_cannot_upload_payload();
        cleanup();
        return fail;
    }
    
    cleanup();
    reboot(1);
    return 0;
}
