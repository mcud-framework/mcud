// Copyright 2010-2019 Espressif Systems (Shanghai) PTE LTD
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
module idf.common.esp_bit_defs;

enum BIT31 = 0x80000000;
enum BIT30 = 0x40000000;
enum BIT29 = 0x20000000;
enum BIT28 = 0x10000000;
enum BIT27 = 0x08000000;
enum BIT26 = 0x04000000;
enum BIT25 = 0x02000000;
enum BIT24 = 0x01000000;
enum BIT23 = 0x00800000;
enum BIT22 = 0x00400000;
enum BIT21 = 0x00200000;
enum BIT20 = 0x00100000;
enum BIT19 = 0x00080000;
enum BIT18 = 0x00040000;
enum BIT17 = 0x00020000;
enum BIT16 = 0x00010000;
enum BIT15 = 0x00008000;
enum BIT14 = 0x00004000;
enum BIT13 = 0x00002000;
enum BIT12 = 0x00001000;
enum BIT11 = 0x00000800;
enum BIT10 = 0x00000400;
enum BIT9 = 0x00000200;
enum BIT8 = 0x00000100;
enum BIT7 = 0x00000080;
enum BIT6 = 0x00000040;
enum BIT5 = 0x00000020;
enum BIT4 = 0x00000010;
enum BIT3 = 0x00000008;
enum BIT2 = 0x00000004;
enum BIT1 = 0x00000002;
enum BIT0 = 0x00000001;

enum BIT63 = 0x80000000UL << 32;
enum BIT62 = 0x40000000UL << 32;
enum BIT61 = 0x20000000UL << 32;
enum BIT60 = 0x10000000UL << 32;
enum BIT59 = 0x08000000UL << 32;
enum BIT58 = 0x04000000UL << 32;
enum BIT57 = 0x02000000UL << 32;
enum BIT56 = 0x01000000UL << 32;
enum BIT55 = 0x00800000UL << 32;
enum BIT54 = 0x00400000UL << 32;
enum BIT53 = 0x00200000UL << 32;
enum BIT52 = 0x00100000UL << 32;
enum BIT51 = 0x00080000UL << 32;
enum BIT50 = 0x00040000UL << 32;
enum BIT49 = 0x00020000UL << 32;
enum BIT48 = 0x00010000UL << 32;
enum BIT47 = 0x00008000UL << 32;
enum BIT46 = 0x00004000UL << 32;
enum BIT45 = 0x00002000UL << 32;
enum BIT44 = 0x00001000UL << 32;
enum BIT43 = 0x00000800UL << 32;
enum BIT42 = 0x00000400UL << 32;
enum BIT41 = 0x00000200UL << 32;
enum BIT40 = 0x00000100UL << 32;
enum BIT39 = 0x00000080UL << 32;
enum BIT38 = 0x00000040UL << 32;
enum BIT37 = 0x00000020UL << 32;
enum BIT36 = 0x00000010UL << 32;
enum BIT35 = 0x00000008UL << 32;
enum BIT34 = 0x00000004UL << 32;
enum BIT33 = 0x00000002UL << 32;
enum BIT32 = 0x00000001UL << 32;

uint BIT(ubyte bit) pure
{
	return 1U << bit;
}

ulong BIT64(ubyte bit) pure
{
	return 1UL << bit;
}
