/**
 * error.c - Part of Ac1dSn0w
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

#include "error.h"

#include <stdio.h>

void error_illegal_ac1d_context_t(const char *func) {
    fprintf(stderr, "[libAc1d error] %s - Illegal ac1d_context_t context.\n", func);
}

void error_illegal_client_handle(const char *func) {
    fprintf(stderr, "[libAc1d error] %s - Illegal client handle .\n", func);
}

void error_illegal_device_handle(const char *func) {
    fprintf(stderr, "[libAc1d error] %s - Illegal device handle.\n", func);
}

void error_illegal_payload_type(const char *func) {
    fprintf(stderr, "[libAc1d error] %s - Illegal payload type.\n", func);
}

void error_not_dfu_mode(const char *func) {
    fprintf(stderr, "[libAc1d error] %s - Device isn't in DFU Mode.\n", func);
}

void error_enter_pwned_dfu(const char *func) {
    fprintf(stderr, "[libAc1d error] %s - Can't enter pwned DFU Mode.\n", func);
}

void error_upload_iBSS(const char *func) {
    fprintf(stderr, "[libAc1d error] %s - Can't upload iBSS.\n", func);
}

void error_upload_iBEC(const char *func) {
    fprintf(stderr, "[libAc1d error] %s - Can't upload iBEC.\n", func);
}

void error_upload_kernelcache(const char *func) {
    fprintf(stderr, "[libAc1d error] %s - Can't upload kernelcache.\n", func);
}

void error_upload_command(const char *func) {
    fprintf(stderr, "[libAc1d error] %s - Can't upload command.\n", func);
}

void error_upload_file(const char *func) {
    fprintf(stderr, "[libAc1d error] %s - Can't upload file.\n", func);
}

void error_upload_buffer(const char *func) {
    fprintf(stderr, "[libAc1d error] %s - Can't upload buffer.\n", func);
}

void error_reconnect(const char *func) {
    fprintf(stderr, "[libAc1d error] %s - Can't reconnect to client.\n", func);
}

void error_reset_counters(const char *func) {
    fprintf(stderr, "[libAc1d error] %s - Can't reset counters.\n", func);
}

void error_boot_args(const char *func) {
    fprintf(stderr, "[libAc1d error] %s - Can't read boot-args.\n", func);
}


void error_upload_ramdisk(const char *func) {
    fprintf(stderr, "[libAc1d error] %s - Can't upload ramdisk.\n", func);
}

void error_upload_bootlogo(const char *func) {
    fprintf(stderr, "[libAc1d error] %s - Can't upload bootlogo.\n", func);
}
