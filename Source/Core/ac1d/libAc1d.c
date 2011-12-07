/**
 * libAc1d.c - Part of Ac1dSn0w
 * Copyright (C) 2011-2012 Manuel Gebele (forensix)
 *
 * Based on Syringe by Chronic-Dev Team
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

#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <bzlib.h>
#include "error.h"
#include "debug.h"
#include "exploits.h"
#include "payloads.h"
#include "libirecovery.h"
#include "libAc1d.h"

#define ITUNES_KILL_CMD "killall -9 iTunesHelper 2>/dev/null"

#define BOOT_TETHERED
#undef  BOOT_RAMDISK

#define  AC1D_UPLOAD_DFU_FILES

irecv_client_t client;
irecv_device_t device;

typedef enum {
    AC1D_IBSS,
    AC1D_IBEC
} ac1d_payload_t;

const char *bundlePath;
const char *kernelcachePath;
const char *iBECPath;
const char *iBSSPath;

// -----------------------------------------------------------------------------
#pragma mark Forward Declarations
// -----------------------------------------------------------------------------

ac1d_error_t exploit_bootrom();
ac1d_error_t upload_command(const char *cmd);
ac1d_error_t upload_file(const char *file);
ac1d_error_t upload_buffer(const unsigned char *buffer, int size, int flag);
ac1d_error_t boot_ramdisk();
ac1d_error_t upload_ramdisk();
ac1d_error_t upload_firmwares();
ac1d_error_t upload_iBSS();
ac1d_error_t upload_iBEC();
ac1d_error_t upload_kernelcache();
ac1d_error_t upload_bootlogo();
ac1d_error_t boot_tethered();
ac1d_error_t reset_counters();
ac1d_error_t reconnect_client(int sec);

// -----------------------------------------------------------------------------
#pragma mark Public API
// -----------------------------------------------------------------------------

ac1d_error_t
ac1d_init(ac1d_context_t ctx, int sock, const char *bundle) {
    ac1d_error_t error = AC1D_E_SUCCESS;
    
    debug_init_ac1d();
    
    bundlePath = bundle;
    
    client = NULL;
    device = NULL;
    
    debug_kill_itunes();
    system(ITUNES_KILL_CMD);
    
    /* Prepare irecv & usbip. */
    debug_init_usb_subsystem();
    /* No libusb debug since libirecovery_context is NULL at this point. */
    //irecv_set_debug_level(1);
    switch (ctx) {
    case AC1D_C_LOCAL:
        irecv_init(IRECV_CTX_LOCAL, -1);
        break;
    case AC1D_C_REMOTE:
        irecv_init(IRECV_CTX_REMOTE, sock);
        break;
    default:
        error_illegal_ac1d_context_t(__func__);
        error = AC1D_E_FAILURE;
        break;
    }
    
    return error;
}

void
ac1d_exit() {
    debug_exit_usb_subsystem();
    
    if (client != NULL)
        irecv_close(client);
    irecv_exit();
    
    client = NULL;
    device = NULL;
    
    debug_exit_ac1d();
}

ac1d_error_t
ac1d_is_compatible() {
    ac1d_error_t error = AC1D_E_FAILURE;
    
    debug_check_compatibility();
    
    if (!client) {
        error_illegal_client_handle(__func__);
        goto failed;
    }
    
    (void)irecv_get_device(client, &device);
    if (!device) {
        error_illegal_device_handle(__func__);
        goto failed;
    } else if (device->index == DEVICE_UNKNOWN) {
        goto device_incompatible; 
    }
    
    debug_print_device(device->product);    
    if (device->index == DEVICE_IPAD1G
     || device->index == DEVICE_IPHONE4
     || device->index == DEVICE_IPOD4G
     || device->index == DEVICE_IPHONE3GS)
    {
        debug_device_compatible();
        return AC1D_E_SUCCESS;
    }
    
device_incompatible:
    debug_device_incompatible();
failed:
    return error;
}

ac1d_device_t ac1d_connected_device() {
    ac1d_device_t conn_device;
    
    switch (device->index) {
    case DEVICE_IPAD1G:
        conn_device = AC1D_D_IPAD1G;
        break;
    case DEVICE_IPHONE4:
        conn_device = AC1D_D_IPHONE4;
        break;
    case DEVICE_IPHONE3GS:
        conn_device = AC1D_D_IPHONE3GS;
        break;
    case DEVICE_IPOD4G:
        conn_device = AC1D_D_IPOD4G;
        break;
    default:
        break;
    }
	
    return conn_device;
}

ac1d_error_t
ac1d_is_ready() {
    irecv_error_t error = IRECV_E_SUCCESS;
    
    /* forensix: Use open_device_with_vid_pid instead. */
    error = irecv_open(&client);
	if (error != IRECV_E_SUCCESS) {
        debug_waiting_for_device();
		return AC1D_E_FAILURE;
	}
    
    if (client->mode != kDfuMode) {
		error_not_dfu_mode(__func__);
		irecv_close(client);
		return AC1D_E_FAILURE;
	}
    
    return AC1D_E_SUCCESS;
}

ac1d_error_t
ac1d_enter_pwned_dfu() {
    if (exploit_bootrom() < 0)
        return AC1D_E_FAILURE;
    
    return AC1D_E_SUCCESS;
}

ac1d_error_t
ac1d_boot_tethered(const char *kernelcache,
                   const char *iBEC,
                   const char *iBSS) {
    ac1d_error_t error = AC1D_E_SUCCESS;
    
    kernelcachePath = kernelcache;
    iBECPath = iBEC;
    iBSSPath = iBSS;
    
    debug_enter_pwned_dfu();
    error = ac1d_enter_pwned_dfu();
    if (error != AC1D_E_SUCCESS) {
        goto enter_pwned_dfu_failed;
    }
    
    debug_reconnect_to_client(2);
	error = reconnect_client(2);
	if (client == NULL)
		return AC1D_E_FAILURE;
    
    upload_firmwares();
    boot_tethered();
    
    return error;
enter_pwned_dfu_failed:
    error_enter_pwned_dfu(__func__);
    goto failed;
failed:
    return error;
}

ac1d_error_t
ac1d_jailbreak(const char *kernelcache,
               const char *iBEC,
               const char *iBSS) {
    ac1d_error_t error = AC1D_E_SUCCESS;
    
    kernelcachePath = kernelcache;
    iBECPath = iBEC;
    iBSSPath = iBSS;
    
    debug_enter_pwned_dfu();
    error = ac1d_enter_pwned_dfu();
    if (error != AC1D_E_SUCCESS) {
        goto enter_pwned_dfu_failed;
    }
    
    debug_reconnect_to_client(2);
	error = reconnect_client(2);
	if (client == NULL)
		return AC1D_E_FAILURE;

    upload_firmwares();
    boot_ramdisk();
    
    return error;
enter_pwned_dfu_failed:
    error_enter_pwned_dfu(__func__);
    goto failed;
failed:
    return error;
}

// -----------------------------------------------------------------------------
#pragma mark Ac1d's Private Area
// -----------------------------------------------------------------------------

ac1d_error_t
exploit_bootrom() {
    int is3GS = 0;
    
    if (device->index == DEVICE_IPHONE3GS)
        is3GS = 1;
        
    return (ac1d_error_t)limera1n_exploit(client, is3GS);
}

ac1d_error_t
boot_ramdisk() {
    ac1d_error_t error = AC1D_E_SUCCESS;
    
    debug_boot_ramdisk();
    
    error = upload_command("go");
    if (error != AC1D_E_SUCCESS) {
        return AC1D_E_FAILURE;
    }
    
    debug_reconnect_to_client(5);
    error = reconnect_client(5);
	if (client == NULL) {
		return AC1D_E_FAILURE;
    }
    
    if (client->mode != kDfuMode) {
        if (reset_counters() != AC1D_E_SUCCESS) {
            return AC1D_E_FAILURE;
        }
    }
    
    debug_upload_ramdisk();
    error = upload_ramdisk();
    if (error != AC1D_E_SUCCESS) {
        return error;
    }
    
    debug_reconnect_to_client(7);
    error = reconnect_client(7);
	if (client == NULL)
		return error;
	
    error = upload_command("ramdisk");
    if(error != AC1D_E_SUCCESS) {
        return error;
    }
	
	if (device->index == DEVICE_IPHONE3GS) {
		if (client->mode != kDfuMode) {
			if (reset_counters() != AC1D_E_SUCCESS) {
				return AC1D_E_FAILURE;
			}
		}
    }
		
    debug_upload_kernelcache();
    error = upload_kernelcache();
    if (error != AC1D_E_SUCCESS) {
        return AC1D_E_FAILURE;
    }
    
    error = upload_command("bootx");
    if (error != AC1D_E_SUCCESS) {
        return error;
    }
    
    return error;
}

ac1d_error_t
boot_tethered() {
    ac1d_error_t error = AC1D_E_SUCCESS;
    
    debug_boot_tethered();

    // After iBEC
    error = upload_command("go");
    if (error != AC1D_E_SUCCESS) {
        return AC1D_E_FAILURE;
    }
    
    debug_reconnect_to_client(2);
    error = reconnect_client(2);
	if (client == NULL) {
		return AC1D_E_FAILURE;
    }
    
    if (client->mode != kDfuMode) {
        if (reset_counters() != AC1D_E_SUCCESS) {
            return AC1D_E_FAILURE;
        }
    }

    debug_upload_kernelcache();
    error = upload_kernelcache();
    if (error != AC1D_E_SUCCESS) {
        return AC1D_E_FAILURE;
    }
    
    error = upload_command("bootx");
    if (error != AC1D_E_SUCCESS) {
        return AC1D_E_FAILURE;
    }
    
    return error;
}


ac1d_error_t
upload_firmwares() {
    ac1d_error_t error = AC1D_E_SUCCESS;
    
    if (client->mode != kDfuMode) {
        if (reset_counters() != AC1D_E_SUCCESS) {
            return AC1D_E_FAILURE;
        }
    }
    
    debug_upload_ibss();
    error = upload_iBSS();
    if (error != AC1D_E_SUCCESS) {
        goto upload_iBSS_failed;
    }
    
    debug_reconnect_to_client(5);
    error = reconnect_client(5);
	if (client == NULL)
		return AC1D_E_FAILURE;
    
    if (client->mode != kDfuMode) {
        if (reset_counters() != AC1D_E_SUCCESS) {
            return AC1D_E_FAILURE;
        }
    }
    
    debug_upload_ibec();
    error = upload_iBEC();
    if (error != AC1D_E_SUCCESS) {
        goto upload_iBEC_failed;
    }    
    
    return error;
upload_iBSS_failed:
    error_upload_iBSS(__func__);
    goto failed;
upload_iBEC_failed:
    error_upload_iBEC(__func__);
failed:
    return error;
}

ac1d_error_t
upload_ramdisk() {
    ac1d_error_t error = AC1D_E_SUCCESS;
    
    // Always the same ramdisk.
    char ramdisk_path[512];
    memset(ramdisk_path, '\0', 512);
    snprintf(ramdisk_path, 511,
             "%s/ASRD.dmg", bundlePath);
    
    error = upload_file(ramdisk_path);
    if (error != AC1D_E_SUCCESS) {
        error_upload_ramdisk(__func__);
    }
    
    return error;
}

ac1d_error_t
upload_iBSS() {
    ac1d_error_t error = upload_file(iBSSPath);
    if (error != AC1D_E_SUCCESS) {
        error_upload_iBSS(__func__);
    }
    return error;
}

ac1d_error_t
upload_iBEC() {
    ac1d_error_t error = upload_file(iBECPath);
    if (error != AC1D_E_SUCCESS) {
        error_upload_iBEC(__func__);
    }
    return error;
}

ac1d_error_t
upload_kernelcache() {
    ac1d_error_t error = upload_file(kernelcachePath);
    if (error != AC1D_E_SUCCESS) {
        error_upload_kernelcache(__func__);
    }
    return error;
}

ac1d_error_t
upload_bootlogo() {
    ac1d_error_t error = AC1D_E_SUCCESS;
    return error;
}

ac1d_error_t
upload_command(const char *cmd) {
    irecv_error_t error = IRECV_E_SUCCESS;
    
    error = irecv_send_command(client, (char *)cmd);
    if (error != IRECV_E_SUCCESS) {
        error_upload_command(__func__);
        return AC1D_E_FAILURE;
	}
    
    return AC1D_E_SUCCESS;
}

ac1d_error_t
upload_file(const char *file) {
    irecv_error_t error = IRECV_E_SUCCESS;
    
    error = irecv_send_file(client, (char *)file, 1);
    if (error != IRECV_E_SUCCESS) {
        error_upload_file(__func__);
        return AC1D_E_FAILURE;
	}
    
    return AC1D_E_SUCCESS;    
}

ac1d_error_t
upload_buffer(const unsigned char *buffer, int size, int flag) {
    irecv_error_t error = IRECV_E_SUCCESS;
    
    error = irecv_send_buffer(client, (unsigned char *)buffer, size, flag);
    if (error != IRECV_E_SUCCESS) {
        error_upload_buffer(__func__);
        return AC1D_E_FAILURE;
	}
    
    return AC1D_E_SUCCESS;    
}

ac1d_error_t
reset_counters() {
    irecv_error_t error = IRECV_E_SUCCESS;
    
    error = irecv_reset_counters(client);
    if (error != IRECV_E_SUCCESS) {
        error_reset_counters(__func__);
        return AC1D_E_FAILURE;
    }
    
    return AC1D_E_SUCCESS;
}

ac1d_error_t
reconnect_client(int sec) {
    client = irecv_reconnect(client, sec);
	if (client == NULL) {
        error_reconnect(__func__);
		return AC1D_E_FAILURE;
    }
    
    return AC1D_E_SUCCESS;
}
