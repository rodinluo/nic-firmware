/* Copyright (c) 2017-2019  Netronome Systems, Inc.  All rights reserved.
 *
 * SPDX-License-Identifier: BSD-2-Clause
 */

;TEST_INIT_EXEC nfp-reg mereg:i32.me0.XferIn_32=0x80

#include "pkt_ipv6_tcp_x88.uc"

#include "actions_rss.uc"

.reg pkt_len
pv_get_length(pkt_len, pkt_vec)

rss_reset_test(pkt_vec)
__actions_rss(pkt_vec)
rss_validate(pkt_vec, NFP_NET_RSS_IPV6, test_assert_equal, 0xe7705213)

rss_validate_range(pkt_vec, NFP_NET_RSS_IPV6, excl, 0, (14 + 8))
rss_validate_range(pkt_vec, NFP_NET_RSS_IPV6, incl, (14 + 8), (14 + 8 + 32))
rss_validate_range(pkt_vec, NFP_NET_RSS_IPV6, excl, (14 + 8 + 32), pkt_len)

test_pass()

PV_SEEK_SUBROUTINE#:
   pv_seek_subroutine(pkt_vec)
