;TEST_INIT_EXEC nfp-mem i32.ctm:0x80  0x00000000 0xffffffff 0xffff0000 0x00000000
;TEST_INIT_EXEC nfp-mem i32.ctm:0x90  0x8100002a 0x08004500 0x002e0000 0x00004011
;TEST_INIT_EXEC nfp-mem i32.ctm:0xa0  0xf96bc0a8 0x0001c0a8 0x00020400 0x0035001a
;TEST_INIT_EXEC nfp-mem i32.ctm:0xb0  0xa3606865 0x6c6c6f20 0x63727565 0x6c20776f
;TEST_INIT_EXEC nfp-mem i32.ctm:0xc0  0x726c640a

#include <aggregate.uc>
#include <stdmac.uc>

#include <pv.uc>

.reg pkt_vec[PV_SIZE_LW]
aggregate_zero(pkt_vec, PV_SIZE_LW)
move(pkt_vec[0], 0x40)
move(pkt_vec[2], 0x84)
move(pkt_vec[3], 0x3)
move(pkt_vec[4], 0x3fcc)
move(pkt_vec[5], ((14 << BF_L(PV_HEADER_OFFSET_L3_bf)) |
                  ((14 + 4 + 20) << BF_L(PV_HEADER_OFFSET_L4_bf))))
move(pkt_vec[6], 1<<BF_L(PV_QUEUE_IN_TYPE_bf))
move(pkt_vec[9], 0x2a)
move(pkt_vec[10], (1 << BF_L(PV_VLD_bf)))
