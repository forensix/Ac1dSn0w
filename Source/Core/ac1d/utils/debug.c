/**
 * debug.c - Part of Ac1dSn0w
 * Copyright (C) 2011-2012 Manuel Gebele (forensix)
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

#include "debug.h"

#include <stdio.h>

void debug_init_ac1d() {
    fprintf(stdout, "[libAc1d] Init libAc1d...\n");
}

void debug_exit_ac1d() {
    fprintf(stdout, "[libAc1d] Exit libAc1d...\n");
}

void debug_kill_itunes() {
    fprintf(stdout, "[libAc1d] Kill iTunes...\n");
}

void debug_init_usb_subsystem() {
    fprintf(stdout, "[libAc1d] Init USB subsystem...\n");
}

void debug_exit_usb_subsystem() {
    fprintf(stdout, "[libAc1d] Exit USB subsystem...\n");
}

void debug_check_compatibility() {
    fprintf(stdout, "[libAc1d] Checking client compatibility...\n");
}

void debug_waiting_for_device() {
    fprintf(stdout, "[libAc1d] Waiting for device...\n");
}

void debug_print_device(const char *name) {
    fprintf(stdout, "[libAc1d] Identified device %s...\n", name);
}

void debug_device_incompatible() {
    fprintf(stdout, "[libAc1d] Device is incompatible...\n");
}

void debug_device_compatible() {
    fprintf(stdout, "[libAc1d] Device is compatible...\n");
}

void debug_enter_pwned_dfu() {
    fprintf(stdout, "[libAc1d] Entering pwned DFU Mode...\n");
}

void debug_upload_ibss() {
    fprintf(stdout, "[libAc1d] Uploading iBSS...\n");
}

void debug_upload_ibec() {
    fprintf(stdout, "[libAc1d] Uploading iBEC...\n");
}

void debug_upload_kernelcache() {
    fprintf(stdout, "[libAc1d] Uploading kernelcache...\n");
}

void debug_upload_bootlogo() {
    fprintf(stdout, "[libAc1d] Uploading bootlogo...\n");
}

void debug_reconnect_to_client(int sec) {
    fprintf(stdout, "[libAc1d] Reconnect to client in %d seconds...\n", sec);
}

void debug_upload_ramdisk() {
    fprintf(stdout, "[libAc1d] Uploading ramdisk...\n");
}

void debug_boot_ramdisk() {
    fprintf(stdout, "[libAc1d] Booting ramdisk...\n");
}

void debug_boot_tethered() {
    fprintf(stdout, "[libAc1d] Booting tethered...\n");
}




