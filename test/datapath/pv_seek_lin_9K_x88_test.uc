#include <single_ctx_test.uc>

#include "pkt_inc_pat_9K_x88.uc"

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
move(increment, 0x00020002)
move(expected, 0x00010002)

pv_seek(pkt_vec, 0)
byte_align_be[--, *$index++]

.while (offset < 9212)
    byte_align_be[tested, *$index++]
    test_assert_equal(tested, expected)
    alu[expected, expected, +, increment]
    alu[offset, offset, +, 4]
    .if_unsigned((offset & 63) == 0)
        pv_seek(pkt_vec, offset)
        byte_align_be[--, *$index++]
    .endif
.endw

test_pass()