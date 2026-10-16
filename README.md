# 7fchain

**The Post-Quantum Blockchain for the People.**

7fchain is a proof-of-work blockchain that is quantum-resistant from its first block. It's built to be mined by ordinary people on ordinary computers — an old laptop or a $20/month server, not ASIC farms or data centers. Layer 1 is a lean post-quantum settlement layer; the 7F L2 Lattice on top is where fast, cheap, stable everyday payments live.

**Two ways to take part:**

- **Run a miner.** Help secure the network and earn 7fCOIN. CPU-mineable, certificate-gated, with a cooldown that keeps rewards spread across the community. → [Become a miner](docs/become-a-miner.md)
- **Build on Layer 2.** Seven Fortunas operates Layer 2 networks for enterprises and governments, and partners can run their own. *(L2 white paper coming as the L2 MVP lands.)*

## Download

Get the binaries for your platform from the [latest Release](https://github.com/Seven-Fortunas/7fchain/releases/latest) — `x86_64-linux`, `aarch64-linux`, `arm64-macos`, or `x86_64-macos`. Every release ships a `SHA256SUMS` file: **always [verify your download](docs/verify-your-download.md) before running it.**

## Already mining? The testnet restarted from block 1

With release `testnet-2026-10-16` the testnet started again from block 1, and
certificates from earlier releases no longer work. If you mined before, three
things to do, all in [installing over an existing installation](docs/verify-your-download.md#installing-over-an-existing-installation):

1. Run `./setup.sh --clean` from the new release. Plain `./setup.sh` would keep
   the old chain database, and the node would not join the new chain.
2. Move your old certificates out of `miner-0/`.
3. Get new ones with `sf-node obtain`. Your API key's allowance has been reset.

Your wallet and keys are kept. New miners can ignore this and follow
[Become a miner](docs/become-a-miner.md).

You can watch the network at **[explore.sevenfortunas.com](https://explore.sevenfortunas.com/)**.

## Documentation

- [Mission & Design](papers/7fchain-mission-and-design.md) — why 7fchain exists *(start here)*
- [Executive Summary](papers/7fchain-executive-summary.md) — the whole project in a few pages
- [L1 White Paper](papers/7fchain-l1-white-paper.md) — the technical design
- [Tokenomics](papers/7fcoin-tokenomics.md) — 7fCOIN supply, rewards, and 7fUSD
- [Constitution](papers/7fchain-constitution.md) — the ethos and the rules we hold ourselves to

*Each paper is provided as Markdown — readable here on GitHub and by AI agents — and as a PDF for download or print, in [`papers/`](papers/).*

## Status

7fchain is on **testnet**. Mainnet launches once the network is producing blocks from 70 distinct, geographically distributed miners — our goal is December 2026, but the condition comes first: the date doesn't override the threshold. **No meme coins. No spam. No scams. Only utility.**

## Free to use

The 7fchain binaries are free to download, run, and share — no license fee, no restrictions. On testnet, miner certificates are free too (see [Become a miner](docs/become-a-miner.md)); on mainnet the only cost to mine will be a low-cost post-quantum miner certificate. The white papers and documentation here are free to read and redistribute.
