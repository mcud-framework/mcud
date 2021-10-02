/* This Source Code Form is subject to the terms of the Mozilla Public *
 * License, v. 2.0. If a copy of the MPL was not distributed with this *
 * file, You can obtain one at https://mozilla.org/MPL/2.0/.           */

MEMORY
{
  FLASH (rx) : ORIGIN = 0x00000000, LENGTH = 0x100000
  EXTFLASH (rx) : ORIGIN = 0x10000000, LENGTH = 0x8000000
  RAM (rwx) : ORIGIN = 0x20000000, LENGTH = 0x40000
  RAM1 (rwx) : ORIGIN = 0x20040000, LENGTH = 0x3F000
}

INCLUDE "linker.ld"