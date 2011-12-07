/**
 * ld_error.c - Part of Ac1dSn0w
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

#include "ld_error.h"
#include "utils.h"

void ld_error_unable_to_mount_fs() {
    puts("[launchd error] Unable to mount filesystems!\n");
}

void ld_error_cannot_upload_payload() {
    puts("[launchd error] Cannot upload payload!\n");
}
