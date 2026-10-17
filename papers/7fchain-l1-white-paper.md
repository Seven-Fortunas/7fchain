**Seven Fortunas, Inc.**

---

# 7fchain: A Post-Quantum Peer-to-Peer Electronic Settlement System

---

## Abstract

A peer-to-peer settlement network secured by post-quantum cryptography from genesis. ML-DSA-65 (NIST FIPS 204) is the only signature algorithm: it signs every transaction, multisig, certificate and registry claim. Peer channels use a PQXDH handshake (ML-KEM-768 with X25519) authenticated by ML-DSA-65, followed by a Triple Ratchet. Mining is permissioned: a miner needs a certificate issued under a published 7F Foundation policy. This is a deliberate trade: it lets the chain cap how many blocks any one miner can take, and Seven Fortunas takes its own certificates on the same terms. A per-certificate block cap, a mining cooldown and a CPU-oriented proof of work keep block production accessible to consumer hardware. The base layer is designed for settlement, and every block hash is timestamped into Bitcoin through OpenTimestamps.

## 1. Introduction

The quantum computing threat to public-key cryptography is no longer theoretical. NIST finalized its first post-quantum standards in August 2024 (FIPS 203, 204, and 205). Federal migration timelines are accelerating. Every blockchain in production today relies on ECDSA or EdDSA signatures that a sufficiently powerful quantum computer can forge.

Adding post-quantum signatures to an existing blockchain is possible but compromised by backwards compatibility. Signature sizes grow by well over an order of magnitude (an ML-DSA-65 signature is 3,309 bytes, versus about 72 bytes for ECDSA). Address formats change. Transaction capacity per block drops. Block validation costs increase. Retrofitting these changes onto a chain with billions of dollars in existing infrastructure, deployed wallets, and hardcoded assumptions creates risk and delay.

7fchain takes a different approach. Rather than retrofit, we start clean: a new Layer 1 designed from the ground up for post-quantum signatures, with block sizes, address formats, transaction structures, and network protocols that account for the larger cryptographic primitives from the first block.

We believe in both Bitcoin and Ethereum and are competing with neither. We had different problems to solve.

## 2. Signatures

7fchain uses one signature algorithm, **ML-DSA-65** (NIST FIPS 204), for everything that is signed: transactions, coinbase payouts, multisig, certificates and Bitcoin registry claims. An ML-DSA-65 public key is 1,952 bytes and a signature is 3,309 bytes.

Blocks themselves are not signed. A block is tied to its miner by its coinbase: output 0 must pay the payout address recorded in the miner's certificate.

Peer links are encrypted and authenticated. Each connection opens with a PQXDH handshake (ML-KEM-768, NIST FIPS 203, combined with X25519), authenticated by the node certificate's ML-DSA-65 key, and then runs a Triple Ratchet. Hashing is SHA-512 throughout: block hashes, transaction ids, addresses and the proof-of-work wrapper.

There are no hash-based signatures in the protocol. ECDSA is not supported on Layer 1. Falcon opcodes are refused; their byte values stay reserved. New algorithms can be added later through their own opcodes: for example ML-DSA-87, or the hash-based SLH-DSA (FIPS 205).

### Transaction Script System

7fchain uses a Bitcoin-style stack-based script system for transaction spending conditions. Each UTXO carries a locking script that defines the conditions for spending, and each input provides an unlocking script with the data to satisfy those conditions. Scripts are intentionally simple: no loops, no recursion, bounded execution.

The script system supports seven categories of opcodes:

| Category | Key Opcodes | Purpose |
|----------|-------------|---------|
| Cryptographic | OP_MLDSA65_CHECKSIG, OP_MLDSA65_CHECKMULTISIG, OP_MLDSA65_ADDRHASH | ML-DSA-65 signature verification, hash-committed multisig, and address hashing |
| Hashing | OP_SHA512 | Hash lock verification for atomic swaps and HTLCs |
| Timelock | OP_CHECKLOCKTIMEVERIFY, OP_CHECKSEQUENCEVERIFY | Absolute and relative time-based spending conditions |
| Flow control | OP_IF, OP_ELSE, OP_ENDIF | Conditional execution paths (e.g., claim-or-refund in HTLCs) |
| Data | OP_RETURN | Provably unspendable outputs for arbitrary data anchoring |
| Comparison | OP_EQUAL, OP_EQUALVERIFY | Value comparison for hash lock matching |
| Bitcoin registry | OP_BTC_CLAIM_PUBLIC, OP_BTC_CLAIM_SEALED, OP_BTC_CLAIM_THIRDPARTY | Provably-unspendable outputs carrying batches of post-quantum ownership claims for Bitcoin addresses |

Standard transaction templates include pay-to-ML-DSA-key-hash (the default), Hash Time-Locked Contracts (for cross-chain atomic swaps), M-of-N ML-DSA multisig, timelocked outputs, OP_RETURN data carriers (for arbitrary metadata), and Bitcoin registry batches. Multisig is hash-committed: the locking script holds only a 64-byte commitment, and the keys are revealed when the output is spent, so they stay off-chain until then. A registry batch is an ordinary transaction: anyone holding 7fCOIN can fund and post one.

## 3. Addresses

An address is the SHA-512 hash of the ML-DSA-65 public key, tagged with a domain label and the parameter set before hashing, and truncated to 25 bytes (200 bits). It is encoded in a Bech32-style format using a 32-character lowercase alphabet. All addresses are 49 characters (7 squared).

| Network | Prefix | Data | Checksum | Total |
|------|--------|------|----------|-------|
| Mainnet | `7f` | 40 characters (200 bits) | 7 characters (35 bits) | 49 |
| Testnet | `t1` | 40 characters (200 bits) | 7 characters (35 bits) | 49 |

Collision resistance is 2^100, exceeding both Bitcoin and Ethereum (2^80). Because the prefix carries the network, nodes reject cross-network transactions, and a testnet address cannot be pasted into a mainnet wallet.

## 4. Transactions

Transactions follow the UTXO model. Each transaction consumes one or more unspent outputs and produces one or more new outputs. Each input includes an ML-DSA-65 signature and public key proving ownership of the consumed output.

Transaction sizes are dominated by the ML-DSA-65 signature (3,309 bytes) and public key (1,952 bytes) in each input, about 5,311 bytes per input in all. Each standard output carries a 25-byte address hash, about 42 bytes per output. Blocks hold up to 4,000,000 bytes.

| Configuration | Size | Transactions per 4 MB Block |
|---|---|---|
| 1 input, 1 output (simple send) | ≈5,379 bytes | ≈743 |
| 1 input, 2 outputs (send + change) | ≈5,421 bytes | ≈737 |
| 2 inputs, 2 outputs | ≈10,732 bytes | ≈372 |

For comparison, a typical Bitcoin transaction is approximately 250 bytes. The roughly twentyfold increase is a direct consequence of post-quantum signature and public key sizes.

This capacity is sufficient for the intended use: Layer 1 is a settlement layer for high-value transfers, not for everyday small payments.

Transaction fees are paid in 7fCOIN. Senders set a fee per kilobyte of transaction size; miners prioritize higher-fee transactions. The minimum fee is 1 7f-sat per kilobyte (rounded up). A standard 5,421-byte transaction (1 input, 2 outputs) costs a minimum of 6 7f-sats.

## 5. Proof of Work

Block production uses a hybrid proof-of-work algorithm combining SHA-512 and RandomX. The proof of work is computed over the block header alone (Bitcoin-style):

```
pow_hash = SHA-512( RandomX( SHA-512(header_bytes) ) )

If pow_hash < difficulty_target: valid block
```

The header includes the miner's unique certificate serial number (a 16-bit issuer prefix plus a 48-bit sequence) alongside the nonce. Because every miner's certificate serial is different, each miner hashes a distinct header from its very first attempt — every certificate begins its search at a different point and explores a different region of the solution space, rather than all miners racing over an identical input. This reduces the criticality of the nonce and produces a natural diversity of solutions. Computation cannot be shared between certificates.

RandomX [tevador/RandomX, github.com] executes randomly generated programs that lean on general-purpose CPU features (branch prediction, out-of-order execution, floating-point arithmetic); mining uses about 2 GB of memory. RandomX has been in production use on the Monero network since 2019. It narrows the efficiency advantage specialized hardware can win. Specialized hardware can still be built for it, and has been, but its advantage is small compared with the thousands-fold gap an SHA-256 ASIC holds over a processor.

Verification requires a single execution of the same three steps: microseconds for each SHA-512, milliseconds for RandomX. Fast to verify, slow to solve.

## 6. Mining and Certificate Lifecycle

Mining is permissioned: a miner needs a certificate issued under a published 7F Foundation policy. This is a deliberate trade: it lets the chain cap how many blocks any one miner can take, and Seven Fortunas takes its own certificates on the same terms.

Certificates are ML-DSA-65 X.509 certificates (RFC 5280, readable by OpenSSL 3.5) in a five-level chain: nine Root keys, a Deputy certified by six of them, CentCom, single-purpose registrars, and leaf certificates. A miner's leaf comes from a miner registrar. The miner certificate binds the reward payout address and a lifetime block cap (`blocks_allowed`). A node's network identity is a separate node certificate.

The payout key and the node's hot key are different keys, both ML-DSA-65. Coinbase output 0 is valid only when it pays the payout address recorded in the certificate, so a stolen hot key cannot redirect rewards. The first block a certificate serial produces on a chain binds that serial to its payout address: if a second certificate is ever issued under the same serial but paying someone else, blocks under it are rejected on that branch. No other secret material is embedded in the certificate.

Revocations are published in one X.509 CRL signed by CentCom and checked when a node accepts a peer. Each block's coinbase carries an informational SHA-512 hash of the CRL the miner observed at mine-time (see Section 10). Without a valid, non-revoked certificate, a node cannot connect to peers or produce blocks.

Certificates found violating the published policy are revoked. Revocation removes a node from peering and block production; it never touches coins already earned (see Section 9).

### Per-Cert `blocks_allowed` Cap

Each miner-purpose certificate carries a `blocks_allowed` integer, set by the issuing CA at signing time and committed under the CA's ML-DSA-65 signature. The value is a **lifetime cap**: the certificate may produce at most `blocks_allowed` blocks across its entire validity window. Every validator maintains a per-cert `blocks_signed` counter against the active chain; once `blocks_signed` reaches `blocks_allowed`, the certificate is *spent* and any further block proposed under it is rejected at consensus. The counter decrements during reorgs so the verdict remains a deterministic function of the canonical chain.

At launch the default is 10 blocks per certificate, with a protocol ceiling of 50 that validators enforce whichever CA signed. The cap is deliberately small, so that earning more rewards means running more certificates, not extracting more from a single one. The default is a CA policy lever that may step down over time as the active mining set grows; existing certificates retain whatever value was stamped at their issuance. Each miner registrar may issue at most 200 certificates, so no single issuer can outweigh the rest of the network.

### Who Gets a Certificate

A central goal of the design is egalitarian distribution: a mining set that is broad, and geographically and demographically diverse, rather than concentrated in a few hands or regions. Miner certificates are issued under a published 7F Foundation policy that serves that goal. The issuance policy works alongside the protocol's own limits: proof of work prevents any single actor from out-hashing the network, the cooldown spreads block production across the active set, and the per-cert cap prevents a single certificate from dominating its window.

### Mining Cooldown

After a certificate produces a valid block, that certificate is ineligible to produce another block for a number of subsequent blocks called the cooldown period. During cooldown, the certificate holder's node continues to validate and relay transactions and blocks; it simply cannot be the miner of a new block. Other certificates remain eligible. The cooldown ensures that no single participant, regardless of hash power, can dominate block production.

The cooldown is **dynamic**, raised as the active mining set grows. It starts at 1 block on a new chain, and the protocol caps it at 1,400 blocks: validators reject any announcement claiming a higher value.

The current cooldown value is published by CentCom in a signed `CooldownAnnouncement` message, gossiped across the network. Each announcement specifies the block height at which a new cooldown takes effect, and every block thereafter declares the cooldown it was mined under. Validators cross-check the declared value against the most recent announcement they have received before that height. The result is both deterministic — every node arrives at the same eligibility rule for every block — and responsive: CentCom can increase the cooldown as the active community grows without requiring a hard fork.

## 7. Difficulty Adjustment

Difficulty adjusts every 1,500 blocks (approximately 7.3 days at the 7-minute target). The algorithm measures the actual elapsed time for the preceding 1,500 blocks and adjusts the target so the next 1,500 blocks average 7-minute intervals. Each adjustment is clamped to a factor of four in either direction. The shorter window — versus the more conventional 14-day cadence — gives the network faster reactivity to hashrate swings during the early mining-set growth phase, while remaining long enough that timestamp manipulation by any individual miner is bounded to a negligible fraction of the window.

## 8. Block Rewards

The initial block reward is 7 7fCOIN, reducing by 7% per decay period of 70,000 blocks (≈340 days at the 7-min target). When the reward reaches 0.07 7fCOIN per block, it remains at that level permanently, providing a tail emission that incentivizes mining indefinitely.

Each block's coinbase transaction distributes 99% to the miner and 1% to the 7fchain development fund. This split applies to both the block reward and transaction fees. The fund is a six-of-nine multisig held by the nine Root holders. It pays for chain software and the registry. Seven Fortunas does not control it alone, so it is not company revenue.

When the reward reaches the 0.07 floor — at block 4,480,000, about 60 calendar years after genesis — the monetary inflation rate reaches about 0.07% and total supply reaches approximately 6.93 million 7fCOIN. Inflation declines every period after. The tail emission of approximately 4,900 coins per ≈340-day decay period (≈5,260 per calendar year) maintains an inflation rate considerably lower than gold (≈1.5%) and any other commodity apart from Bitcoin.

## 9. Network

A node starts from the seed peers listed in its configuration and checks its chain against a set of trusted peers before it mines, and discovers further peers by gossip. Every peer connection opens with the authenticated PQXDH handshake described in Section 2, including certificate chain verification.

Nodes only relay transactions bearing valid ML-DSA-65 signatures; the mempool rejects transactions with invalid signatures. Certificate revocation is independent of coin ownership. A certificate grants network access and mining eligibility; revoking it removes the node from peering and block production but does not reach the addresses that received past rewards. 7fCOIN already paid to an address remains fully spendable by the holder of that address's private key, regardless of the issuing certificate's status. The certificate's hot key and the cold payout key are kept strictly separate, so the right to spend property never depends on the standing of any certificate.

## 10. CRL Distribution

Certificate revocations are tracked in a Certificate Revocation List (CRL), distributed between nodes rather than written to Layer 1 blocks. Revocations are published in one X.509 CRL signed by CentCom and checked when a node accepts a peer. A single CRL revokes leaf certificates and, when needed, a compromised intermediate such as a registrar.

Root compromise is not recoverable through a CRL. It is guarded against up front: nine Root keys are held by separate holders on nine air-gapped machines, and six of the nine must agree before any Root action takes effect.

Each block's coinbase carries one informational field for CRL accounting: a SHA-512 hash of the canonical CRL bytes the miner observed at mine-time (`crl_hash`). It is not a consensus rule; blocks are never rejected because of the value of `crl_hash`. It serves as an audit trail visible in block explorers and as a soft signal for offline nodes to detect CRL changes. When no CRL has yet been issued, `crl_hash` is the SHA-512 of the empty string — a canonical placeholder that lets nodes verify the field rather than special-case its absence.

## 11. Genesis Block and Bitcoin Anchoring

The genesis block is built from a Root-signed chain definition (`genesis-config.json`) containing the network kind, a timestamp, a label, the consensus parameters, and the Roots' ML-DSA-65 signatures over its exact bytes. The node binary embeds the Root verification keys; it accepts the definition only when six distinct Root signatures verify against them. A separate Root-signed configuration (`devfund-config.json`) specifies the 7fchain development fund address that receives the 1% coinbase share.

**Root model.** Nine Root keys are held by separate holders on nine air-gapped machines. Six of the nine must sign before a chain definition, a development fund recipient or a Deputy can exist, so no single key can create or redefine the network. The testnet ceremony has been held; the mainnet ceremony takes place before launch. Three Roots can be lost or compromised without forging anything.

Six colluding Root holders would be a real power, and it is worth stating plainly. They could sign a competing genesis, or stand up a certificate authority issuing miner certificates the foundation never approved. They could not spend anyone's coins or rewrite work already done, and they could not quietly replace history already committed into Bitcoin. That is why the Roots sit with separate holders.

**No premine.** The genesis block contains no treasury outputs and no timelocked allocations. There is no premine, no founder or investor allocation and no token sale. The genesis block mints one ordinary reward of 7 7fCOIN to the development fund; every other 7fCOIN is mined. Investors are not buying tokens, and 7fchain launches with or without investors.

**Bitcoin anchoring.** 7fchain block hashes are written to Bitcoin through OpenTimestamps, so the chain's history can be checked without trusting Seven Fortunas. Each commitment over the current 7fchain tip hash lands in a Bitcoin transaction and inherits Bitcoin's proof-of-work security as an external audit anchor. Any third party can independently verify that a specific 7fchain block existed at or before a specific Bitcoin block height: a time-dated proof of the block hashes, a defense-in-depth check against deep reorgs, and a public timestamp that does not depend on trusting 7F's certificate authority. The OpenTimestamps proofs are published for anyone to verify. The anchoring is informational and does not affect 7fchain consensus rules.

The coinbase carries the founding message: "No meme coins. No spam. No scams. Focused on utility, security and decentralization."

The same binary can serve testnet or mainnet by providing different signed genesis configuration files.

## 12. Status

Testnet is live. It launched in 2026 on the nine-Root federation and runs mainnet protocol values. Mainnet launches when the network reaches 70 distinct miners, with December 2026 as the goal: the condition comes first, the date second. The node source is shared with beta operators now and is open-sourced, with an external audit, before mainnet.

## 13. Conclusion

7fchain provides a settlement layer where every signature is post-quantum from genesis. Mining is permissioned by design, and the certificate is what lets the chain cap any one miner's share. The CPU-oriented proof of work, per-certificate cap and mining cooldown keep block production distributed among individuals. Every block hash is timestamped into Bitcoin, so the chain's history is provable to anyone. The deliberately constrained base layer avoids the scaling debates that have divided other blockchain communities.

The chain is designed to be run by the people who believe in it.

---

*Seven Fortunas, Inc. | US-based | AI-first | Compliance-first | Military-Grade Security*
