/**
 * libAc1d.h - Part of Ac1dSn0w
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

typedef enum {
    AC1d_E_DUMMY = -1,
    AC1D_E_FAILURE,
    AC1D_E_SUCCESS
} ac1d_error_t;

typedef enum {
    AC1D_C_LOCAL,
    AC1D_C_REMOTE
} ac1d_context_t;

typedef enum {
	AC1D_D_IPAD1G,
	AC1D_D_IPHONE4,
	AC1D_D_IPHONE3GS,
	AC1D_D_IPOD4G
} ac1d_device_t;

void            ac1d_exit();
ac1d_error_t    ac1d_init(ac1d_context_t ctx, int sock, const char *bundle);
ac1d_error_t    ac1d_is_compatible();
ac1d_error_t    ac1d_is_ready();
ac1d_error_t    ac1d_enter_pwned_dfu();
ac1d_error_t    ac1d_boot_tethered(const char *kernelcache, const char *iBEC, const char *iBSS);
ac1d_error_t    ac1d_jailbreak(const char *kernelcache, const char *iBEC, const char *iBSS);
ac1d_device_t	ac1d_connected_device();


