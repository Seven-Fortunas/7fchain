**Seven Fortunas, Inc.**

---

# 7fchain Tokenomics

---

## Why Another Layer 1?

Bitcoin proved that decentralized money works. Ethereum proved that programmable money works. Neither was designed for the post-quantum era, and neither was designed with Layer 2 as a first-class citizen from genesis.

7fchain exists because we needed a blockchain where every signature is quantum-resistant from the first block, where Layer 2 utility is built into the architecture from day one, where mining stays accessible to individuals running nodes on consumer hardware, and where the chain is protected from spam, scams, and meme coins by design. We are big believers in both Bitcoin and Ethereum and are competing with neither. We had different problems to solve.

7fchain uses a two-token model. **7fCOIN** is the scarce Layer 1 asset, mined through proof of work and secured by Falcon-512 signatures. **7fUSD** is a fully-backed utility token that serves as the common unit of value and the intermediate currency for swaps across the Layer 2 superchain. Each Layer 2 chain runs its own tokens and sets its own gas; 7fUSD is the default, keeping fees cheap and stably priced where it is used.

## Proof of Work for Node Runners

7fchain's proof of work combines SHA-512 with RandomX, an algorithm designed to run efficiently on consumer CPUs. Mining is intended to reward individuals running nodes from old laptops in their homes, not ASICs and large data centers. A mining cooldown schedule limits how frequently any single node can solve a block, ensuring that expensive hardware does not translate into proportionally more rewards.

The mining set is further bounded by CA-issued policy levers documented in the L1 white paper (Section 6). The exact parameters are still being finalized ahead of mainnet, but the design intent is fixed:

- **Per-cert block-production cap.** Every miner certificate carries a lifetime cap on the number of blocks it can ever produce. Once a certificate reaches its cap it is *spent*, and any further block under it is rejected at consensus. This bounds the total supply any single certificate can ever earn.
- **Bounded active mining set.** The CA targets a large but finite population of simultaneously-active miner certificates — on the order of the 70,000-miner goal that gives the chain its name. The mechanism for keeping the network open to newcomers once the set is full is being finalized.
- **Partner-led distribution.** Miner certificates are distributed through a network of regional partners (up to ~700) rather than sold directly. Allocations are sized so that, as the partner roster grows, the network approaches its active-mining target gradually and across many regions. Allocation is increasingly measured in *block allowance* rather than raw certificate count.

Seven Fortunas operates Layer 2 chains for its customers and enables others to run their own Layer 2 chains on the 7fchain superchain. Layer 2 operators are also node runners, contributing hash power to Layer 1 security while operating their own chains. Partners frequently overlap with L2 operators, L2 validators, and L2 cashiers — the same regional entity that distributes miner certs in its territory typically anchors the L2 economy there too. Transparent dashboards publish blocks-per-region and blocks-per-partner so the egalitarian distribution goal is auditable against actual realized supply.

---

## 7fCOIN Supply Schedule

7fCOIN follows a 7-7-7-7 model: 7 coins per block, 7-minute block intervals, 7% reduction per decay period, 70,000-block decay period (≈340 days). When the block reward reaches 0.07 7fCOIN per block, it stays at that level permanently, providing a perpetual tail emission that keeps miners incentivized without meaningful inflation.

| Period | Reward per Block | Mined per Period | Cumulative Supply | Inflation |
|------|------------------|------------------|-------------------|-----------|
| 0 (genesis) | pre-mine | 70,000 | 70,000 | n/a |
| 1 | 7.0000 | 490,000 | 560,000 | n/a |
| 5 | 5.2364 | 366,500 | 2,200,000 | 20.0% |
| 10 | 3.6429 | 255,000 | 3,682,000 | 7.5% |
| 20 | 1.7631 | 123,400 | 5,431,000 | 2.3% |
| 30 | 0.8533 | 59,700 | 6,276,000 | 1.0% |
| 50 | 0.1999 | 13,990 | 6,884,000 | 0.20% |
| 70 | 0.0700 (floor) | 4,900 | 7,031,000 | 0.07% |
| 100 | 0.0700 (floor) | 4,900 | 7,178,000 | 0.07% |

**Note on units.** A *period* is one decay period of `BLOCKS_PER_YEAR = 70,000` blocks ≈ 340 days at the 7-minute target block interval — roughly 93% of a calendar year, so the table covers about 93 calendar years through Period 100. The per-block reward column is consensus-invariant; only the per-period mined quantity depends on the period length.

The decay floor engages around period 64. After that the per-block reward holds permanently at 0.07 7fCOIN and total supply approaches the ≈7 million 7fCOIN equilibrium. The tail emission — roughly 4,900 coins per ≈340-day period, or ≈5,260 per calendar year — is intentionally small but never zero: the network's security budget compounds with adoption rather than collapsing to a fee-only model the way Bitcoin's eventually must. Implied inflation at the floor is approximately 0.07% and falls every period thereafter, well below gold (≈1.5%) and below every commodity except Bitcoin. The smallest unit is the 7f-sat (0.00000001 7fCOIN; 100,000,000 per coin).

Each block's coinbase splits 99% to the miner and 1% to the 7fchain Developer Fund (applies to both block rewards and transaction fees). Layer 1 transaction fees are paid in 7fCOIN using a Bitcoin-style fee market with a minimum of 1 7f-sat.

## Pre-Mine: Corporate Treasury

70,000 7fCOIN are created in the genesis block as a corporate treasury asset. This represents less than 1% of the total supply.

| Property | Value |
|----------|-------|
| Total pre-mine | 70,000 7fCOIN (100 wallets × 700) |
| Pre-mine as % of period-100 supply | ≈1.0% |
| Lock period | Fully locked for 2 years from genesis |
| Unlock schedule | 700 7fCOIN every 7,000 blocks (≈34 days) for 100 unlocks; first unlock block 140,000, last block 833,000 |
| Unlock as % of mining over the same ≈34-day interval (period 1) | 1.5% |

Each ≈34-day unlock of 700 coins is minimal relative to the ≈48,510 coins paid to miners over the same interval in period 1 (7,000 blocks × 7 7fCOIN × 99/100). All 100 treasury addresses are public from genesis. Time-locks are enforced at the consensus level via CLTV. Seven Fortunas holds these as a corporate treasury asset and does not plan to sell 7fCOIN from its treasury.

---

## 7fUSD Economics

7fUSD is the superchain's fully-backed utility token. It is minted by Seven Fortunas against off-chain reserves and serves as the common unit of value across Layer 2 — used to move value, swap between chains, and post as the canonical collateral for bond-locks across the superchain. Each Layer 2 chain runs its own tokens and sets its own gas; 7fUSD is the default, keeping fees cheap and stably priced where it is used.

### Issuance and Backing

7fUSD is a fully-backed stablecoin targeting $1 per token. Issuance is controlled at the protocol level by CentCom (Tier 3 in the seven-tier key hierarchy — see L1 white paper). New 7fUSD is minted only when corresponding backing assets are deposited into segregated reserves; on redemption, the corresponding 7fUSD is burned and the equivalent USD is released. The 1:1 backing invariant is maintained on every mint and burn.

Backing composition is conservative and transparent:

- **Short-duration US Treasury bills** — primary reserve. Default-free and yield-bearing.
- **Cash and cash equivalents** — buffer for redemption velocity.
- **Other high-grade short-duration instruments** — may be added over time as scale warrants, with disclosure.

Reserves are held in segregated custody at regulated financial institutions. Proof of reserves is published periodically and independently audited.

### Stability Mechanism

7fUSD's $1 target is maintained by direct 1:1 backing — not by algorithmic mechanisms. Algorithmic stablecoins have repeatedly failed under stress (Terra/UST being the most prominent example). Fully-collateralized backing is more capital-intensive but is the model that has survived every market cycle. Seven Fortunas chooses the more conservative model deliberately.

### Demand Drivers

Beyond the baseline demand of being a common unit of value across Layer 2, 7fUSD has structural demand sources that compound with network adoption:

- **Gas across the Layer 2 superchain.** Layer 2 transactions settle fees in 7fUSD wherever it is the configured gas token. As L2 transaction volume grows, 7fUSD circulation grows with it.
- **Cross-token swap intermediate.** Every cross-token, cross-chain, or external swap routes through 7fUSD on the L2-Swap chain. The intermediate 7fUSD is structural transit volume.
- **Bond collateral on the L2-Swap chain.** Every cashier, sequencer, verifier, validator, and other service provider holds bond-locked UTXOs (see L2 white paper §5–§6). 7fUSD is the natural default denomination because it carries no token-specific volatility risk. This is **persistent, locked, non-circulating demand** — capital committed to remain on-chain for the bond lifecycle (60-day minimum script-enforced lock; typically much longer in practice).
- **Bridge facilitator working capital.** Every external bridge (USDC-on-Base, USDT-on-Tron, etc.) requires the facilitator to hold 7fUSD inventory on the L2-Swap side.

---

## Layer 2 Assets

Layer 1 carries only 7fCOIN. Layer 2 chains support additional assets:

- **7fUSD** — the superchain's fully-backed unit of value (see §above).
- **w7fCOIN** — wrapped 7fCOIN; 1:1 backed by 7fCOIN locked on Layer 1; tradeable on Layer 2.
- **7fBTC** — wrapped Bitcoin; 1:1 backed by BTC held in Seven Fortunas cold storage with auditable addresses and periodic independent audit.
- **Partner-issued tokens** — gift cards, local-currency denominations, country-specific utility tokens, wrapped real-world assets — issued by partner-operated L2 chains under the same governance-controlled token-definition mechanism every 7fchain token uses.

Seven Fortunas maintains a diversified corporate treasury: 7fCOIN as a long-term reserve, US Treasury bills backing 7fUSD issuance, and Bitcoin backing 7fBTC.

---

*Seven Fortunas, Inc. | US-based | AI-first | Compliance-first | Military-Grade Security*
