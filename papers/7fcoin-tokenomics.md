**Seven Fortunas, Inc.**

---

# 7fchain Tokenomics

---

## Why Another Layer 1?

Bitcoin proved that decentralized money works. Ethereum proved that programmable money works. Neither was designed for the post-quantum era, and neither was designed with Layer 2 as a first-class citizen from genesis.

7fchain exists because we needed a blockchain where every signature is quantum-resistant from the first block, where Layer 2 utility is built into the architecture from day one, where mining stays accessible to individuals running nodes on consumer hardware, and where the chain is protected from spam, scams, and meme coins by design. We are big believers in both Bitcoin and Ethereum and are competing with neither. We had different problems to solve.

7fchain uses a two-token model. **7fCOIN** is the scarce Layer 1 asset, mined through proof of work and secured by ML-DSA-65 signatures. **7fUSD** is a protocol-maintained utility token — held to a low, stable band rather than pegged to $1 — that serves as the default gas token and the intermediate currency for swaps across the 7F L2 Lattice. Each Layer 2 chain runs its own tokens and sets its own gas; 7fUSD is the default, keeping fees cheap and stably priced where it is used.

## Proof of Work for Node Runners

7fchain's proof of work combines SHA-512 with RandomX, an algorithm designed to run efficiently on consumer CPUs. Mining is intended to reward individuals running nodes from old laptops in their homes, not ASICs and large data centers. A mining cooldown schedule limits how frequently any single node can solve a block, ensuring that expensive hardware does not translate into proportionally more rewards.

The mining set is further bounded by policy levers in the certificates the CA issues:

- **Per-cert block-production cap.** Every miner certificate carries a lifetime cap on the number of blocks it can ever produce. Once a certificate reaches its cap it is *spent*, and any further block under it is rejected at consensus. This bounds the total supply any single certificate can ever earn.
- **Bounded active mining set.** The CA targets a large but finite population of simultaneously-active miner certificates — on the order of the 70,000-miner goal that gives the chain its name. Because every certificate has a lifetime block cap, certificates retire as they are spent, so the network stays open to newcomers even when the set is full.
- **Partner-led distribution.** Miner certificates are distributed through a network of regional partners (up to ~700) rather than sold directly. Allocations are sized so that, as the partner roster grows, the network approaches its active-mining target gradually and across many regions. Allocation is increasingly measured in *block allowance* rather than raw certificate count.

Seven Fortunas operates Layer 2 chains for its customers and enables others to run their own Layer 2 chains on the 7F L2 Lattice. Layer 2 operators are also node runners, contributing hash power to Layer 1 security while operating their own chains. Partners frequently overlap with L2 operators, L2 validators, and L2 cashiers — the same regional entity that distributes miner certs in its territory typically anchors the L2 economy there too. Transparent dashboards publish blocks-per-region and blocks-per-partner so the egalitarian distribution goal is auditable against actual realized supply.

---

## 7fCOIN Supply Schedule

7fCOIN follows a 7-7-7-7 model: 7 coins per block, 7-minute block intervals, 7% reduction per decay period, 70,000-block decay period (≈340 days). When the block reward reaches 0.07 7fCOIN per block, it stays at that level permanently, providing a perpetual tail emission that keeps miners incentivized without meaningful inflation.

| Period | Reward per Block | Mined per Period | Cumulative Supply | Inflation |
|------|------------------|------------------|-------------------|-----------|
| 1 | 7.0000 | 490,000 | 490,000 | n/a |
| 5 | 5.2364 | 366,545 | 2,130,000 | 20.8% |
| 10 | 3.6429 | 255,001 | 3,612,000 | 7.6% |
| 20 | 1.7631 | 123,416 | 5,360,000 | 2.4% |
| 30 | 0.8533 | 59,731 | 6,206,000 | 0.97% |
| 50 | 0.1999 | 13,991 | 6,814,000 | 0.21% |
| 70 | 0.0700 (floor) | 4,900 | 6,962,000 | 0.07% |
| 100 | 0.0700 (floor) | 4,900 | 7,109,000 | 0.07% |

**Note on units.** A *period* is one decay period of `BLOCKS_PER_YEAR = 70,000` blocks ≈ 340 days at the 7-minute target block interval — roughly 93% of a calendar year, so the table covers about 93 calendar years through Period 100. The per-block reward column is consensus-invariant; only the per-period mined quantity depends on the period length.

The reward reaches the 0.07 floor in period 65, at block 4,480,000, about 60 calendar years after genesis. From then on the per-block reward holds permanently at 0.07 7fCOIN and total supply approaches the ≈7 million 7fCOIN equilibrium. The tail emission — roughly 4,900 coins per ≈340-day period, or ≈5,260 per calendar year — is intentionally small but never zero: the network's security budget compounds with adoption rather than collapsing to a fee-only model the way Bitcoin's eventually must. Implied inflation at the floor is approximately 0.07% and falls every period thereafter, well below gold (≈1.5%) and below every commodity except Bitcoin. The smallest unit is the 7f-sat (0.00000001 7fCOIN; 100,000,000 per coin).

Each block's coinbase splits 99% to the miner and 1% to the 7fchain development fund (applies to both block rewards and transaction fees). The fund is a six-of-nine multisig held by the nine Root holders; moving it takes six of them. It pays for chain software and the registry. Seven Fortunas does not control it alone, so it is not company revenue. Layer 1 transaction fees are paid in 7fCOIN using a Bitcoin-style fee market with a minimum of 1 7f-sat.

## No Premine

There is no premine, no founder or investor allocation and no token sale. The genesis block mints one ordinary reward of 7 7fCOIN to the development fund; every other 7fCOIN is mined. Seven Fortunas has not sold 7fCOIN, and 7fchain launches with or without investors.

The issuance record is provable against Bitcoin. 7fchain block hashes are written to Bitcoin through OpenTimestamps, giving time-dated proof of every block from genesis onward, so anyone can check that no block, and no reward in it, was added or rewritten after the fact.

---

## 7fUSD Economics

7fUSD is the 7F L2 Lattice's utility token, not a dollar-pegged stablecoin. It is minted and burned at the protocol level and serves as the common gas and value-transfer unit across Layer 2 — used to pay transaction fees, move value, and swap between chains. Each Layer 2 chain runs its own tokens and sets its own gas; 7fUSD is the default, keeping fees cheap and stably priced where it is used. (7fUSD is separate from Seven Fortunas' fully collateralized, dollar-pegged payments stablecoin, which runs on EVM chains.)

### Issuance

Issuance is controlled at the protocol level by each Layer 2 chain's governance federation. The federation appoints a MasterMinter, which grants each minter a capped allowance that consensus enforces. 7fUSD is minted when a Layer 2 facilitator funds a user's balance, and burned when the corresponding gas is consumed or a user bridges out — tying supply directly to actual network usage rather than to a reserve.

### Stability Mechanism

7fUSD is deliberately held to a low, protocol-maintained band rather than tracking $1 — its job is to keep Layer 2 gas cheap and predictable, not to serve as a store of value or a financial instrument. This is a different design choice from a collateral-backed $1 stablecoin, made because 7fUSD's role is paying fees on 7fchain's own network rather than representing dollars off-chain.

### Demand Drivers

Beyond the baseline demand of being the common gas token across Layer 2, 7fUSD has structural demand sources that compound with network adoption:

- **Gas across the 7F L2 Lattice.** Layer 2 transactions settle fees in 7fUSD wherever it is the configured gas token. As L2 transaction volume grows, 7fUSD circulation grows with it.
- **Cross-token swap intermediate.** Every cross-token, cross-chain, or external swap routes through 7fUSD on the L2-Swap chain. The intermediate 7fUSD is structural transit volume.
- **Bond collateral on the L2-Swap chain.** Sequencers, verifiers and other Layer 2 service providers hold bond-locked UTXOs. 7fUSD is the natural default denomination because its value is held to a protocol-maintained band rather than floating with the market. This is **persistent, locked, non-circulating demand** — capital committed to remain on-chain for the life of the bond.
- **Bridge facilitator working capital.** Every external bridge (USDC-on-Base, USDT-on-Tron, etc.) requires the facilitator to hold 7fUSD inventory on the L2-Swap side.

---

## Layer 2 Assets

Layer 1 carries only 7fCOIN. Layer 2 chains support additional assets:

- **7fUSD** — the 7F L2 Lattice's utility gas token (see §above).
- **w7fCOIN** — wrapped 7fCOIN; 1:1 backed by 7fCOIN locked on Layer 1; tradeable on Layer 2.
- **7fBTC** — wrapped Bitcoin; 1:1 backed by BTC held in Seven Fortunas cold storage with auditable addresses and periodic independent audit.
- **Partner-issued tokens** — gift cards, local-currency denominations, country-specific utility tokens, wrapped real-world assets — issued by partner-operated L2 chains under the same governance-controlled token-definition mechanism every 7fchain token uses.

Seven Fortunas holds Bitcoin backing 7fBTC.

---

*Seven Fortunas, Inc. | US-based | AI-first | Compliance-first | Military-Grade Security*
