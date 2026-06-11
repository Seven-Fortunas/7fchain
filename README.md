# 7fchain

**The post-quantum blockchain for people who move money.**

7fchain is a proof-of-work blockchain built for the financial corridors that legacy providers underserve. Quantum-resistant from its first block - not retrofitted later, but designed that way from the start. Any ordinary computer can mine it: an old laptop, a $20/month server. No GPU, no ASIC.

Layer 1 is lean, secure settlement. The Layer 2 superchain on top is where fast, cheap, stable everyday payments live - remittances, stablecoins, AI-to-AI payments.

**Two ways to take part:**

- **Run a miner.** Secure the network and earn 7fCOIN. CPU-mineable, certificate-gated, with a cooldown that keeps rewards spread fairly. → [Become a miner](docs/become-a-miner.md)
- **Build on Layer 2.** Seven Fortunas operates L2 networks for remittances, stable money, and enterprise payments. Partners can run their own. *(L2 white paper coming when the L2 MVP ships.)*

## Download

Get the binaries for your platform from the [latest Release](https://github.com/Seven-Fortunas/7fchain/releases/latest) - `x86_64-linux`, `aarch64-linux`, `arm64-macos`, or `x86_64-macos`. Every release ships a `SHA256SUMS` file. **Always [verify your download](docs/verify-your-download.md) before running it.**

## Documentation

- [Mission & Design](papers/7fchain-mission-and-design.md) - why 7fchain exists *(start here)*
- [Executive Summary](papers/7fchain-executive-summary.md) - the whole project in a few pages
- [L1 White Paper](papers/7fchain-l1-white-paper.md) - the technical design
- [Tokenomics](papers/7fcoin-tokenomics.md) - 7fCOIN supply, rewards, and 7fUSD
- [Constitution](papers/7fchain-constitution.md) - the ethos and the rules we hold ourselves to

*Each paper comes as Markdown - readable here on GitHub and by AI agents - and as a PDF in [`papers/`](papers/).*

## What makes it different

**Post-quantum from block one.** 7fchain uses Falcon-512 signatures (NIST FIPS 206) for transactions and ML-DSA for certificates. Algorithms built to resist quantum computers - not a retrofit of an existing chain.

**Fair mining economics.** 7fCOIN supply is capped at ~7 million coins with no founder pre-mine and no insider allocation. A per-certificate cooldown keeps rewards spread across the community rather than pooled. A small perpetual tail emission (~0.07%) funds miners long after block rewards decay - the security-budget problem Bitcoin doesn't solve.

**Certificate-gated.** Every node runs with a post-quantum certificate from a geographically distributed partner network. Sybil attacks are expensive; proven bad actors can be revoked.

## Status

7fchain is on **testnet**. Mainnet launches once the network is producing blocks from 700 distinct, geographically distributed miners - a participation milestone, not a calendar date.

**No meme coins. No spam. No scams. Only utility.**

## Free to use

The binaries are free to download, run, and share. The only cost to mine is a low-cost post-quantum miner certificate (see [Become a miner](docs/become-a-miner.md)). Papers and documentation are free to read and redistribute.
