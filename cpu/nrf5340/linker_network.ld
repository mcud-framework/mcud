/* This Source Code Form is subject to the terms of the Mozilla Public *
 * License, v. 2.0. If a copy of the MPL was not distributed with this *
 * file, You can obtain one at https://mozilla.org/MPL/2.0/.           */

MEMORY
{
  FLASH (rx) : ORIGIN = 0x1000000, LENGTH = 0x40000
  EXTFLASH (rx) : ORIGIN = 0x10000000, LENGTH = 0x8000000
  RAM (rwx) : ORIGIN = 0x21000000, LENGTH = 0x10000
  RAM1 (rwx) : ORIGIN = 0x20000000, LENGTH = 0x40000 /* Application core RAM */
  RAM2 (rwx) : ORIGIN = 0x20040000, LENGTH = 0x40000 /* Application core RAM */
}

INCLUDE "linker.ld"
