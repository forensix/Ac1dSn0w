/**
 * debug.h - Part of Ac1dSn0w
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

void debug_init_ac1d();
void debug_exit_ac1d();
void debug_kill_itunes();
void debug_init_usb_subsystem();
void debug_exit_usb_subsystem();
void debug_check_compatibility();
void debug_waiting_for_device();
void debug_print_device(const char *name);
void debug_device_incompatible();
void debug_device_compatible();
void debug_enter_pwned_dfu();
void debug_upload_ibss();
void debug_upload_ibec();
void debug_upload_kernelcache();
void debug_upload_bootlogo();
void debug_reconnect_to_client(int sec);
void debug_upload_ramdisk();
void debug_boot_ramdisk();
void debug_boot_tethered();