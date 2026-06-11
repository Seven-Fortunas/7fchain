**Seven Fortunas, Inc.**

---

# 7fchain Executive Summary

---

## The Vision

7fchain is a post-quantum native blockchain built for two audiences: node runners who believe in decentralization and security, and businesses that need real utility from blockchain infrastructure.

Layer 1 is deliberately simple and small, optimized for decentralization. Its certificate chain is signed with ML-DSA-65 and its value — coinbase rewards and transactions — with Falcon-512, post-quantum from genesis, while proof of work runs on RandomX, tuned for consumer CPUs rather than ASICs or data centers. Because post-quantum signatures are large, a 1 MB block holds far fewer transactions than Bitcoin — by design: Layer 1 is a settlement layer, carrying little beyond the Layer 2 rollups that anchor to it. Layer 2 is where utility lives: cheap, stable gas, AI-agent-friendly payments, and specialized chains for customers from global remittance providers to institutional banking partners.

Seven Fortunas operates the Post-Quantum Certificate Authority (PQCA) that gates entry to the network. Every node runner, Layer 2 operator, and verifier holds a certificate that chains to the same root CA that signed the genesis block; a node without a valid certificate cannot peer or participate.

## What Makes 7fchain Different

**Post-quantum from the first block.** The certificate chain uses ML-DSA-65 (NIST FIPS 204) and all value — transactions and coinbase rewards — uses Falcon-512 (FIPS 206); even the peer handshake is certificate-authenticated. This isn't a retrofit: the chain was designed around post-quantum signatures, and the larger keys and address formats they require, from the start.

**Certificate-gated network.** Every node runner holds a post-quantum certificate, bought from a regional partner — a worldwide partner network that keeps participation geographically distributed, so no single nation or region holds the chain. The certificate is the entry ticket: without one, a node can't peer or produce blocks — which makes Sybil attacks costly and lets proven bad actors be revoked.

**Egalitarian mining.** 7fchain seats up to **70,000 active miners** around the world, with rules built so each has a real shot at a block. Proof of work runs on RandomX — consumer CPUs, not ASICs or data centers — a cooldown makes a certificate stand aside after it mines so rewards spread across the community, and a lifetime cap per certificate keeps any one seat from dominating. An old laptop is a meaningful vote.

**Layer 2 from day one.** 7fchain skips Bitcoin's scaling wars: Layer 1 is a 1 MB settlement layer; Layer 2 chains carry the volume, the smart contracts, and the consumer apps. Seven Fortunas runs Layer 2 chains for its customers and lets partners run their own on the 7fchain superchain. Seven Fortunas already ships **mobile apps (Android and iPhone)** that talk to any L2 and adapt easily to different L2 use cases.

**Two-token economics.** 7fCOIN is the scarce Layer 1 asset — roughly 7 million coins by the time the decay floor engages, after which a small perpetual tail (about 0.07 coins per block) keeps miners paid at roughly **0.07% inflation**, well below gold's historic ~1.5%. **7fUSD** is a Layer 2 stablecoin targeting $1, used to move value and **swap between chains** — each Layer 2 runs its own tokens and sets its own (low) gas, typically fractions of a cent to a few cents per transaction.

**No meme coins, no spam, no scams.** 7fchain keeps out noise from day one — only honest utility: utility coins, stablecoins, gift cards, and seasoned investment assets. The certificate requirement, the mining cooldown, and Layer 2 operator licensing all create friction against abuse while staying open to legitimate participants.

## The 7fchain Superchain

Seven Fortunas coordinates a superchain of Layer 2 networks, all settling on 7fchain Layer 1. **7F-operated chains** serve customers directly — global remittance and telecom payments, permissioned intercompany banking, and consumer gift-card ecosystems for cross-border corridors. **Partner-operated chains** let any organization run its own Layer 2: register with Seven Fortunas, post a bond, run your own sequencer — keep your Layer 2 gas fees while settling on Layer 1.

A dedicated **L2-Swap** chain is the hub for inter-chain transfers — move assets between any two Layer 2 chains in about ten seconds. A dedicated **L2-Markets** chain provides a post-quantum-adapted decentralized exchange and collateral lending for 7fchain assets (w7fCOIN, 7fBTC, 7fUSD).

## Security Architecture

Seven Fortunas brings a seven-pillar, military-grade security architecture — built by a team with deep experience in military-grade encryption, PKI, and high-value key protection. Genesis keys are generated in air-gapped facilities on FIPS 140 Level 4 tamper-responsive hardware; the genesis block is signed by the 7F root CA and timestamped to Bitcoin via OpenTimestamps. Layer 1 blocks are anchored to Bitcoin roughly every 70 blocks (about every 8 hours), giving every Layer 2 settlement an external, tamper-evident timestamp.

## Launch Strategy

7fchain launches on testnet first — proving the network with real node runners around the world before any value is at stake — then mainnet once it's stable with a healthy number of nodes.

---

*Seven Fortunas, Inc. | US-based | AI-first | Compliance-first | Military-Grade Security*
