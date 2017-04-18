/* Optimization and simplifying assumptions */
// - 4 CTX mode
// - LM Index 0 is reserved for local use (code that does not call into other code)
// - Single NBI
// - Single PCIe

.num_contexts 4

#include "pkt_io.uc"
#include "actions.uc"

#define PKT_COUNTER_ENABLE
#include "pkt_counter.uc"

pkt_counter_decl(drop)
pkt_counter_decl(err_act)
pkt_counter_decl(err_rx_nbi)
pkt_counter_decl(err_rx_nfd)

// cache the context bits for T_INDEX
.reg volatile t_idx_ctx
local_csr_rd[ACTIVE_CTX_STS]
immed[t_idx_ctx, 0]
alu[t_idx_ctx, t_idx_ctx, AND, 7]
alu[t_idx_ctx, --, B, t_idx_ctx, <<7]

.reg pkt_vec[PV_SIZE_LW]
pkt_io_init(pkt_vec)

// kick off processing loop
br[ingress#]

error_rx_nbi#:
    pkt_counter_incr(err_rx_nbi)
    br[count_drop#]

error_rx_nfd#:
    pkt_counter_incr(err_rx_nfd)
    br[count_drop#]

/*
error_act#:
    pkt_counter_incr(err_act)
*/

count_drop#:
    pkt_counter_incr(drop)

silent_drop#:
    pkt_io_drop(pkt_vec)

egress#:
    pkt_io_reorder(pkt_vec)

ingress#:
    pkt_io_rx(pkt_vec, error_rx_nbi#, error_rx_nfd#)

    actions_execute(pkt_vec, egress#, count_drop#, silent_drop#, error_act#)

nop
