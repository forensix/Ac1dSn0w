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

// mnt stuff
#define ROOT_DEV_PATH   "/dev/disk0s1s1"
#define ROOT_MNT_PATH   "/mnt"
#define USER_DEV_PATH   "/dev/disk0s1s2"
#define USER_MNT_PATH   "/mnt1"
#define DISK_DEV_PATH   "/dev/disk0s1"
#define CONS_DEV_PATH   "/dev/console"

// Target
#define LD_PLIST    "/payload/ac1dismygift.plist"
#define BASH        "/payload/bash"
#define CYDIA_PATCH "/payload/ASCydiaPatcher"
#define CYDIA       "/payload/Cydia.tar.gz"
#define IPAD_PATCH  "/payload/K48AP.plist"
#define FSTAB       "/payload/fstab"
#define AC1DDROP    "/payload/ac1ddrop"
#define GZIP        "/payload/gzip"
#define LIBGCC      "/payload/libgcc_s.1.dylib"
#define LIBHISTORY  "/payload/libhistory.6.0.dylib"
#define LIBICONV    "/payload/libiconv.2.dylib"
#define LIBNCURSES  "/payload/libncurses.5.dylib"
#define LIBREADLINE "/payload/libreadline.6.0.dylib"
#define LIBSYSTEM   "/payload/libSystem.B.dylib"
#define RM          "/payload/rm"
#define TAR         "/payload/tar"

// Destination
#define DESTINATION_DIR         "/mnt/ac1dismygift/"
#define LD_PLIST_INSTALL_PATH   "/mnt/System/Library/LaunchDaemons/ac1dismygift.plist"
#define BASH_INSTALL_PATH       "/mnt/bin/bash"
#define CYDIA_PATCH_INSTALL_PATH "/mnt/ac1dismygift/ASCydiaPatcher"
#define CYDIA_INSTALL_PATH      "/mnt/ac1dismygift/Cydia.tar.gz"
#define IPAD_PATCH_INSTALL_PATH "/mnt/System/Library/CoreServices/SpringBoard.app/K48AP.plist"
#define FSTAB_INSTALL_PATH      "/mnt/private/etc/fstab"
#define AC1DDROP_INSTALL_PATH   "/mnt/ac1dismygift/ac1ddrop"
#define GZIP_INSTALL_PATH       "/mnt/bin/gzip"
#define LIBGCC_INSTALL_PATH     "/mnt/usr/lib/libgcc_s.1.dylib"
#define LIBHISTORY_INSTALL_PATH "/mnt/usr/lib/libhistory.6.0.dylib"
#define LIBICONV_INSTALL_PATH   "/mnt/usr/lib/libiconv.2.dylib"
#define LIBNCURSES_INSTALL_PATH "/mnt/usr/lib/libncurses.5.dylib"
#define LIBREADLINE_INSTALL_PATH "/mnt/usr/lib/libreadline.6.0.dylib"
#define LIBSYSTEM_INSTALL_PATH  "/mnt/usr/lib/libSystem.B.dylib"
#define RM_INSTALL_PATH         "/mnt/ac1dismygift/rm"
#define TAR_INSTALL_PATH        "/mnt/ac1dismygift/tar"

const char *ld_plist[]      = { LD_PLIST, LD_PLIST_INSTALL_PATH };
const char *bash[]          = { BASH, BASH_INSTALL_PATH                 };
const char *cydia_patch[]   = { CYDIA_PATCH, CYDIA_PATCH_INSTALL_PATH   };
const char *cydia[]         = { CYDIA, CYDIA_INSTALL_PATH               };
const char *ipad_patch[]    = { IPAD_PATCH, IPAD_PATCH_INSTALL_PATH     };
const char *fstab[]         = { FSTAB, FSTAB_INSTALL_PATH               };
const char *ac1ddrop[]      = { AC1DDROP, AC1DDROP_INSTALL_PATH         };
const char *gzip[]          = { GZIP, GZIP_INSTALL_PATH                 };
const char *libgcc[]        = { LIBGCC, LIBGCC_INSTALL_PATH             };
const char *libhistory[]    = { LIBHISTORY, LIBHISTORY_INSTALL_PATH     };
const char *libiconv[]      = { LIBICONV, LIBICONV_INSTALL_PATH         };
const char *libncurses[]    = { LIBNCURSES, LIBNCURSES_INSTALL_PATH     };
const char *libreadline[]   = { LIBREADLINE, LIBREADLINE_INSTALL_PATH   };
const char *libsystem[]     = { LIBSYSTEM, LIBSYSTEM_INSTALL_PATH       };
const char *rm[]            = { RM, RM_INSTALL_PATH                     };
const char *tar[]           = { TAR, TAR_INSTALL_PATH                   };
