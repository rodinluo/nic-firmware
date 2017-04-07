#ifndef __GRO_CFG_UC
#define __GRO_CFG_UC

#include "nfd_user_cfg.h"

#ifndef GRO_ISL
#error "GRO_ISL not defined"
#endif

#define NFD_RINGHI(isl)         (0x80 | isl)

/* Global mandetory parameters */
#ifndef GRO_NUM_BLOCKS
    #define GRO_NUM_BLOCKS          4
#endif

#ifndef GRO_CTX_PER_BLOCK
    #define GRO_CTX_PER_BLOCK       2
#endif

#if 0
#macro nfd_out_ring_declare()
    #ifdef NFD_PCIE0_EMEM
        .alloc_resource \
            nfd_out_ring_num00 NFD_PCIE0_EMEM/**/_queues global 1 1
    #endif /* NFD_PCIE0_EMEM */

    #ifdef NFD_PCIE1_EMEM
        .alloc_resource \
            nfd_out_ring_num10 NFD_PCIE1_EMEM/**/_queues global 1 1
    #endif /* NFD_PCIE1_EMEM */

    #ifdef NFD_PCIE2_EMEM
        .alloc_resource \
            nfd_out_ring_num20 NFD_PCIE2_EMEM/**/_queues global 1 1
    #endif /* NFD_PCIE2_EMEM */

    #ifdef NFD_PCIE3_EMEM
        .alloc_resource \
            nfd_out_ring_num30 NFD_PCIE3_EMEM/**/_queues global 1 1
    #endif /* NFD_PCIE3_EMEM */
#endm
#else
    #include <nfd_out.uc>
#endif

#macro gro_config_block(BLOCKNUM, CALLER)

    /* Set up the 8 GRO CTXs                        */
    /* Using island GRO_ISL CTM for bitmaps              */
    /* Using island 24 to hold the reorder queues   */
    /* Size of each reorder queue is 8K             */
        gro_declare_ctx(BLOCKNUM, CALLER, 0, GRO_ISL, 24, 2048)

        gro_declare_ctx(BLOCKNUM, CALLER, 1, GRO_ISL, 24, 2048)

        gro_declare_ctx(BLOCKNUM, CALLER, 2, GRO_ISL, 24, 2048)

        gro_declare_ctx(BLOCKNUM, CALLER, 3, GRO_ISL, 24, 2048)

        gro_declare_ctx(BLOCKNUM, CALLER, 4, GRO_ISL, 24, 2048)

        gro_declare_ctx(BLOCKNUM, CALLER, 5, GRO_ISL, 24, 2048)

        gro_declare_ctx(BLOCKNUM, CALLER, 6, GRO_ISL, 24, 2048)

        gro_declare_ctx(BLOCKNUM, CALLER, 7, GRO_ISL, 24, 2048)


    /* Netdev wire does not send to NBI, so no NBI dest         */
    /* gro_declare_dest_nbi(BLOCKNUM, CALLER, 0, GRO_1_SEQR)    */
    /* gro_declare_dest_nbi(BLOCKNUM, CALLER, 1, GRO_1_SEQR)    */

    /* Declare the ring IDs with the same exact names as in nfd_out.h */
    /* This will allocate nfd_out_ring_num<isl>0                      */
    nfd_out_ring_declare()

    /* Declare NFD dests for GRO */
    #ifdef NFD_PCIE0_EMEM
        #define_eval __EMEM_NUM strright('NFD_PCIE0_EMEM', 1)
        #define_eval NFD0_RING_ISL   (24 + __EMEM_NUM)
        gro_declare_dest_nfd3_allq(BLOCKNUM, CALLER, 0,
                                   NFD_RINGHI(NFD0_RING_ISL),
                                   nfd_out_ring_num00)
    #endif
    #ifdef NFD_PCIE1_EMEM
        #define_eval __EMEM_NUM strright('NFD_PCIE1_EMEM', 1)
        #define_eval NFD1_RING_ISL   (24 + __EMEM_NUM)
        gro_declare_dest_nfd3_allq(BLOCKNUM, CALLER, 1,
                                   NFD_RINGHI(NFD1_RING_ISL),
                                   nfd_out_ring_num10)
    #endif
    #ifdef NFD_PCIE2_EMEM
        #define_eval __EMEM_NUM strright('NFD_PCIE2_EMEM', 1)
        #define_eval NFD2_RING_ISL   (24 + __EMEM_NUM)
        gro_declare_dest_nfd3_allq(BLOCKNUM, CALLER, 2,
                                   NFD_RINGHI(NFD2_RING_ISL),
                                   nfd_out_ring_num20)
    #endif
    #ifdef NFD_PCIE3_EMEM
        #define_eval __EMEM_NUM strright('NFD_PCIE3_EMEM', 1)
        #define_eval NFD3_RING_ISL   (24 + __EMEM_NUM)
        gro_declare_dest_nfd3_allq(BLOCKNUM, CALLER, 3,
                                   NFD_RINGHI(NFD3_RING_ISL),
                                   nfd_out_ring_num30)
    #endif
#endm

#endif /* __GRO_CFG_UC */
