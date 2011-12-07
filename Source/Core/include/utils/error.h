/**
 * error.h - Part of Ac1dSn0w
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

void error_illegal_ac1d_context_t(const char *func);
void error_illegal_client_handle(const char *func);
void error_illegal_device_handle(const char *func);
void error_illegal_payload_type(const char *func);
void error_not_dfu_mode(const char *func);
void error_enter_pwned_dfu(const char *func);
void error_upload_iBSS(const char *func);
void error_upload_iBEC(const char *func);
void error_upload_kernelcache(const char *func);
void error_upload_command(const char *func);
void error_upload_file(const char *func);
void error_upload_buffer(const char *func);
void error_reconnect(const char *func);
void error_reset_counters(const char *func);
void error_boot_args(const char *func);
void error_upload_ramdisk(const char *func);
void error_upload_bootlogo(const char *func);