/*
 * Copyright (C) 2015 Netronome, Inc. All rights reserved.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *   http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 *
 * @file          apps/nic/app_config_instr.h
 * @brief         Header file for App Config ME instruction table
 */

#ifndef _APP_CONFIG_INSTR_H_
#define _APP_CONFIG_INSTR_H_


/* if NBI 1 has any ports then two NIB islands */
#if NS_PLATFORM_NUM_PORTS_PER_MAC_1 > 0
#define NUM_NBI 2
#else
#define NUM_NBI 1
#endif

#define NUM_NBI_CHANNELS    64      // channels per NBI
#define NUM_PCIE            2       // number of PCIe islands
#define NUM_PCIE_Q          64      // number of queues configured per PCIe
#define NUM_PCIE_Q_PER_PORT 8       // NFD_MAX_PF_QUEUES // nr queues cfg per port
#define NIC_MAX_INSTR       16      // 64 bytes, 4B per instruction

#define NIC_HOST_MAX_ENTRIES  (NUM_PCIE*NUM_PCIE_Q)
#define NIC_NBI_ENTRY_START   NIC_HOST_MAX_ENTRIES
#define NIC_WIRE_MAX_ENTRIES  (NUM_NBI*NUM_NBI_CHANNELS)


#define NIC_CFG_INSTR_TBL_ADDR 0x00
#define NIC_CFG_INSTR_TBL_SIZE (((NIC_HOST_MAX_ENTRIES+NIC_WIRE_MAX_ENTRIES) \
                                * NIC_MAX_INSTR)<<2)

/* For host ports,
 *   use 0 to NIC_HOST_MAX_ENTRIES-1
 * For wire ports,
 *   use NIC_HOST_MAX_ENTRIES .. NIC_WIRE_MAX_ENTRIES+NIC_HOST_MAX_ENTRIES*/
#if defined(__NFP_LANG_ASM)

    .alloc_mem NIC_CFG_INSTR_TBL cls+NIC_CFG_INSTR_TBL_ADDR \
                island NIC_CFG_INSTR_TBL_SIZE addr40
    .init NIC_CFG_INSTR_TBL 0 0

#elif defined(__NFP_LANG_MICROC)

    __asm
    {
        .alloc_mem NIC_CFG_INSTR_TBL cls + NIC_CFG_INSTR_TBL_ADDR \
                    island NIC_CFG_INSTR_TBL_SIZE addr40
        .init NIC_CFG_INSTR_TBL 0 0
    }
    
#endif

#define INSTR_PIPELINE_BIT 16
#define INSTR_OPCODE_LSB   17

#endif /* _APP_CONFIG_INSTR_H_ */
