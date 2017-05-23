#include <single_ctx_test.uc>

#include "pkt_inc_pat_256B_x80.uc"

#include <config.h>
#include <gro_cfg.uc>
#include <global.uc>
#include <pv.uc>
#include <stdmac.uc>

.reg increment
.reg offset
.reg expected
.reg tested

move(offset, 0)
move(increment, 0x04040404)
move(expected, 0x01020304)

pv_seek(pkt_vec, 0, PV_SEEK_CTM_ONLY)
byte_align_be[--, *$index++]

.while (offset < 252)
    byte_align_be[tested, *$index++]
    test_assert_equal(tested, expected)
    alu[expected, expected, +, increment]
    alu[offset, offset, +, 4]
    .if_unsigned((offset & 63) == 0)
        pv_seek(pkt_vec, offset, PV_SEEK_CTM_ONLY)
        byte_align_be[--, *$index++]
    .endif
.endw

test_pass()
