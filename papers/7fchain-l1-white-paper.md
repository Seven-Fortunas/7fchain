**Seven Fortunas, Inc.**

---

# 7fchain: A Post-Quantum Peer-to-Peer Electronic Settlement System

---

## Abstract

A peer-to-peer settlement network secured by post-quantum cryptography from genesis. Falcon-512 signatures secure all transactions and addresses. ML-DSA-65 signatures secure the certificate chain, peer handshakes, and network identity. A certificate-gated proof-of-work system requires each miner to hold a post-quantum certificate issued by a trusted Certificate Authority, creating an authenticated network resistant to sybil attacks while remaining open to any individual willing to participate. A mining cooldown schedule and ASIC-resistant proof of work keep block production accessible to consumer hardware. The base layer is designed for settlement; transaction volume is handled by Layer 2 chains that roll up to Layer 1 periodically. Layer 1 is designed for the best decentralization and security protection by the people who believe in it and run it.

## 1. Introduction

The quantum computing threat to public-key cryptography is no longer theoretical. NIST finalized its first post-quantum standards in August 2024 (FIPS 203, 204, and 205); the Falcon-based FN-DSA standard (FIPS 206) is forthcoming. Federal migration timelines are accelerating. Every blockchain in production today relies on ECDSA or EdDSA signatures that a sufficiently powerful quantum computer can forge.

Adding post-quantum signatures to an existing blockchain is possible but compromised by backwards compatibility. Signature sizes increase by an order of magnitude (Falcon-512 signatures average 650 bytes versus ECDSA's 72 bytes). Address formats change. Transaction capacity per block drops. Block validation costs increase. Retrofitting these changes onto a chain with billions of dollars in existing infrastructure, deployed wallets, and hardcoded assumptions creates risk and delay.

7fchain takes a different approach. Rather than retrofit, we start clean: a new Layer 1 designed from the ground up for post-quantum signatures, with block sizes, address formats, transaction structures, and network protocols that account for the larger cryptographic primitives from the first block.

We believe in both Bitcoin and Ethereum and are competing with neither. We had different problems to solve.

## 2. Signatures

7fchain uses two post-quantum signature algorithms, each selected for its strengths in a specific role.

**Falcon-512** (the basis for NIST's forthcoming FN-DSA standard, FIPS 206) secures all transactions and wallet addresses. Falcon is a lattice-based signature scheme built on the NTRU lattice problem, selected for its signature size (approximately 650 bytes average, up to 752 bytes maximum), the smallest of any NIST post-quantum signature scheme, and its stateless design, which permits unlimited signatures from a single key pair without security degradation.

**ML-DSA-65** (NIST FIPS 204) secures the certificate authority chain, node communications identity, and peer-to-peer handshakes. ML-DSA-65 provides the network's authentication layer: every node holds an ML-DSA-65 certificate issued by a trusted CA, and all peer handshakes are authenticated using ML-DSA-65 signatures.

ECDSA is not supported on Layer 1. An extensible signature type field in the transaction format permits future post-quantum algorithms and zero-knowledge proofs to be added via soft fork.

WOTS+ (Winternitz One-Time Signature) is reserved as an optional future signature type for cold storage addresses. WOTS+ provides hash-based security (independent of lattice assumptions) at the cost of single-use: each WOTS+ key pair may sign exactly one message, which the UTXO model accommodates naturally. The address format and opcode are defined in the protocol; full opcode implementation is tracked on the L1 design roadmap.

### Transaction Script System

7fchain uses a Bitcoin-style stack-based script system for transaction spending conditions. Each UTXO carries a locking script that defines the conditions for spending, and each input provides an unlocking script with the data to satisfy those conditions. Scripts are intentionally simple: no loops, no recursion, bounded execution.

The script system supports seven categories of opcodes:

| Category | Key Opcodes | Purpose |
|----------|-------------|---------|
| Cryptographic | OP_FALCON_CHECKSIG, OP_FALCON_CHECKMULTISIG, OP_MLDSA_CHECKSIG | Signature verification (Falcon-512 for transactions, ML-DSA-65 for CA operations) |
| Hashing | OP_SHA512 | Hash lock verification for atomic swaps and HTLCs |
| Timelock | OP_CHECKLOCKTIMEVERIFY, OP_CHECKSEQUENCEVERIFY | Absolute and relative time-based spending conditions |
| Flow control | OP_IF, OP_ELSE, OP_ENDIF | Conditional execution paths (e.g., claim-or-refund in HTLCs) |
| Data | OP_RETURN | Provably unspendable outputs for arbitrary data anchoring |
| Comparison | OP_EQUAL, OP_EQUALVERIFY | Value comparison for hash lock matching |
| L2 Superchain | OP_ROLLUP, OP_REGISTER_CHAIN | Provably-unspendable outputs carrying structured, signed L2 manifests parsed and validated at L1 consensus |

Standard transaction templates include Pay-to-Falcon-PubKey-Hash (the default), Hash Time-Locked Contracts (for cross-chain atomic swaps), M-of-N Falcon multisig, timelocked outputs (for genesis treasury wallets with periodic block-height unlock schedules), OP_RETURN data carriers (for arbitrary metadata), and L2 superchain transactions using OP_ROLLUP / OP_REGISTER_CHAIN (see Section 11).

## 3. Addresses

Addresses are derived from the SHA-512 hash of the Falcon or WOTS+ public key, encoded in a Bech32-style format using a 32-character lowercase alphabet. All addresses are 49 characters (7 squared).

| Type | Prefix | Data | Checksum | Total |
|------|--------|------|----------|-------|
| Falcon | `7f` | 40 characters (200 bits) | 7 characters (35 bits) | 49 |
| WOTS+ | `7fw1` | 40 characters (200 bits) | 5 characters (25 bits) | 49 |

Collision resistance is 2^100, exceeding both Bitcoin and Ethereum (2^80). Testnet addresses use prefixes `t1` (Falcon) and `t1w1` (WOTS+). Nodes reject cross-network transactions.

## 4. Transactions

Transactions follow the UTXO model. Each transaction consumes one or more unspent outputs and produces one or more new outputs. Each input includes a Falcon-512 signature proving ownership of the consumed output.

Transaction sizes are dominated by the Falcon-512 signature (≈650 bytes average) and public key (897 bytes) in each input's unlocking script. Each output carries a locking script (≈28 bytes for standard Pay-to-Falcon-PubKey-Hash).

| Configuration | Size | Transactions per 1 MB Block |
|---|---|---|
| 1 input, 1 output (simple send) | ≈1,590 bytes | ≈628 |
| 1 input, 2 outputs (send + change) | ≈1,618 bytes | ≈617 |
| 2 inputs, 2 outputs (common) | ≈3,170 bytes | ≈315 |
| 1 input + OP_ROLLUP L2 anchor | ≈9,000 bytes | ≈116 |

For comparison, a typical Bitcoin transaction is approximately 250 bytes. The 7x to 13x increase is a direct consequence of post-quantum signature and public key sizes.

The largest standard transaction is a Layer 2 rollup anchor: an OP_ROLLUP carrier runs about 9 KB, dominated by its ≈7 KB header — which carries two ML-DSA-65 signatures, the sequencer's and an independent verifier's, at ≈3.3 KB each. A single such anchor settles an entire L2 batch of hundreds of thousands — even millions — of transactions, since only the state roots and off-chain archive locations are written to Layer 1.

This capacity is sufficient for the intended use: Layer 1 is a settlement layer. Layer 2 rollup transactions and rare high-value transfers are the primary Layer 1 traffic. Individual user transactions occur on Layer 2.

Transaction fees are paid in 7fCOIN. Senders set a fee per kilobyte of transaction size; miners prioritize higher-fee transactions. The minimum fee is 1 7f-sat per kilobyte (rounded up). A typical 1,685-byte transaction (1 input, 2 outputs) costs a minimum of 2 7f-sats.

## 5. Proof of Work

Block production uses a hybrid proof-of-work algorithm combining SHA-512 and RandomX. The proof of work is computed over the block header alone (Bitcoin-style):

```
pow_hash = SHA-512( RandomX( SHA-512(header_bytes) ) )

If pow_hash < difficulty_target: valid block
```

The header includes the miner's unique certificate serial number (a 16-bit issuer prefix plus a 48-bit sequence) alongside the nonce. Because every miner's certificate serial is different, each miner hashes a distinct header from its very first attempt — every certificate begins its search at a different point and explores a different region of the solution space, rather than all miners racing over an identical input. This reduces the criticality of the nonce and produces a natural diversity of solutions: there is no single shared input for specialized hardware to race on. Computation cannot be shared between certificates.

RandomX [tevador/RandomX, github.com] requires a 2 GB memory scratchpad and executes randomly generated programs that use CPU features (branch prediction, out-of-order execution, floating-point arithmetic) that ASICs cannot optimize. RandomX has been in production use on the Monero network since 2019. A consumer CPU competes fairly with specialized hardware.

Verification requires a single execution of the same three steps: microseconds for each SHA-512, milliseconds for RandomX. Fast to verify, slow to solve.

## 6. Mining and Certificate Lifecycle

Every miner must hold an ML-DSA-65 certificate issued by a Seven Fortunas intermediate Certificate Authority, which chains to the root CA that signed the genesis block. The miner certificate binds three things: (a) the node's ML-DSA-65 communications identity, (b) a Falcon-512 block-reward address, and (c) a lifetime per-cert block-production cap (`blocks_allowed`). Coinbase outputs are valid only when paid to the Falcon address recorded in the issuing certificate, so a stolen ML-DSA key cannot redirect rewards. No other secret material is embedded in the certificate.

Certificate state is tracked through a Certificate Revocation List (CRL), distributed via P2P gossip and signed by authorized Tier 5 Cert Analyzer agents (cloud software with certs signed by the CentCom intermediate CA). Multiple analyzers run simultaneously for redundancy. Each block's coinbase carries an informational SHA-512 hash of the CRL the miner observed at mine-time (see Section 10). Without a valid, non-revoked certificate, a node cannot connect to peers, relay transactions, or produce blocks.

Miner behavior is continuously monitored for abuse, and certificates found violating network policy are revoked. Seven Fortunas operates a transparent revocation policy — the rules, and the per-node observations behind any revocation, are public — so revocations are auditable by operators, partners, and the public.

### Per-Cert `blocks_allowed` Cap

Each miner-purpose certificate carries a `blocks_allowed` integer, set by the issuing CA at signing time and committed under the CA's ML-DSA-65 signature. The value is a **lifetime cap**: the certificate may sign at most `blocks_allowed` blocks across its entire validity window. Every validator maintains a per-cert `blocks_signed` counter against the active chain; once `blocks_signed` reaches `blocks_allowed`, the certificate is *spent* and any further block proposed under it is rejected at consensus. The counter decrements during reorgs so the verdict remains a deterministic function of the canonical chain.

The cap is deliberately small — on the order of tens of blocks per certificate on mainnet at launch — so that earning more rewards means running more certificates, not extracting more from a single one. The exact value is a per-network-tier CA policy lever: the CA enforces a hard ceiling for each tier and stamps every certificate at or below it, and may step the default down over time as the active mining set grows. Existing certificates retain whatever value was stamped at their issuance. The value is provided by the issuing CA under its tier policy.

### Active-Cert Ceiling and One-Shot Certs

A central goal of the design is to maximize egalitarian distribution, and the current plan bounds the network at roughly **70,000 simultaneously-active miner certificates** — the figure that gives the chain its name. The ceiling is intended to be applied by the CA at issuance time rather than by validators at consensus: any certificate that chains to root and is unrevoked is honored regardless of the count. As the active set approaches this ceiling, the plan is for the CA to keep welcoming new miners while issuing their certificates with a very small lifetime cap — in the limit, one-shot certificates good for a single block — so newcomers can always participate without the active set growing without bound. The exact ceiling and the mechanics for staying open at the top are still being finalized.

### Geographic Partner Distribution

To keep the mining set geographically and demographically diverse, miner certificates are issued through a network of regional **partners** rather than sold from one central store. The program targets a worldwide roster of up to **700 partners**, each allocated a bounded budget of miner-cert issuances per period — sized so the per-partner allocation slides down as the roster grows, keeping any one partner from dominating. Partners are simultaneously **miners and promoters** of the chain in their region; many also operate L2 chains, serve as L2 validators or cashiers, or run other services on the network.

Seven Fortunas publishes transparent dashboards tracking blocks-per-region and blocks-per-partner so that the actual realized distribution can be audited against the egalitarian goal. The partner program complements the per-cert `blocks_allowed` cap and the mining cooldown: proof of work prevents any single actor from out-hashing the network, the cooldown spreads block production across the active set, the per-cert cap prevents a single certificate from dominating its window, and the partner allocation prevents geographic over-concentration.

### Mining Cooldown

After a certificate produces a valid block, that certificate is ineligible to produce another block for a number of subsequent blocks called the cooldown period. During cooldown, the certificate holder's node continues to validate and relay transactions and blocks; it simply cannot be the miner of a new block. Other certificates remain eligible. The cooldown ensures that no single participant, regardless of hash power, can dominate block production.

The cooldown is **dynamic**, scaled to the size of the active mining set. The target is approximately 2% of active miners: a network of 700 active miners runs an ≈14-block cooldown; a network of 7,000 active miners runs an ≈140-block cooldown. Under the current plan's ceiling of roughly 70,000 active certificates, the cooldown reaches at most 1,400 blocks — a protocol-level cap. Validators reject any announcement claiming a value above 1,400 regardless of how the active-miner count is computed.

The current cooldown value is published by CentCom in a signed `CooldownAnnouncement` message, gossiped across the network. Each announcement specifies the block height at which a new cooldown takes effect, and every block thereafter declares the cooldown it was mined under. Validators cross-check the declared value against the most recent announcement they have received before that height. The result is both deterministic — every node arrives at the same eligibility rule for every block — and responsive: CentCom can increase the cooldown as the active community grows without requiring a hard fork.

## 7. Difficulty Adjustment

Difficulty adjusts every 1,500 blocks (approximately 7.3 days at the 7-minute target). The algorithm measures the actual elapsed time for the preceding 1,500 blocks and adjusts the target so the next 1,500 blocks average 7-minute intervals. The shorter window — versus the more conventional 14-day cadence — gives the network faster reactivity to hashrate swings during the early mining-set growth phase, while remaining long enough that timestamp manipulation by any individual miner is bounded to a negligible fraction of the window.

## 8. Block Rewards

The initial block reward is 7 7fCOIN, reducing by 7% per decay period of 70,000 blocks (≈340 days at the 7-min target). When the reward reaches 0.07 7fCOIN per block, it remains at that level permanently, providing a tail emission that incentivizes mining indefinitely.

Each block's coinbase transaction distributes 99% to the miner and 1% to the 7fchain Developer Fund address. This split applies to both the block reward and transaction fees.

At year 64 — when the decay floor engages — the monetary inflation rate reaches 0.07% and total supply reaches approximately 7 million 7fCOIN. Inflation declines every period after. The tail emission of approximately 4,900 coins per ≈340-day decay period (≈5,260 per calendar year) maintains an inflation rate considerably lower than gold (≈1.5%) and any other commodity apart from Bitcoin.

## 9. Network

Peer discovery uses a hybrid model. On first boot, a node contacts the Seven Fortunas backend via post-quantum encrypted channel and receives a list of verified peers. Subsequent peer discovery uses a gossip protocol. Every peer handshake includes ML-DSA-65 certificate chain verification.

Nodes only relay transactions bearing valid Falcon-512 signatures; the mempool rejects transactions with invalid signatures. Certificate revocation is independent of coin ownership. A certificate binds an ML-DSA-65 network identity and mining eligibility; revoking it removes the node from peering and block production but does not reach the Falcon-512 addresses that received past rewards. 7fCOIN already paid to a Falcon address remains fully spendable by the holder of that Falcon private key regardless of the issuing certificate's status. Money signatures (Falcon-512) and identity signatures (ML-DSA-65) are kept strictly separate, so the right to spend property never depends on the standing of any certificate.

## 10. CRL Distribution

Certificate revocations are tracked in a Certificate Revocation List (CRL), distributed via P2P gossip rather than written to Layer 1 blocks. CRL updates are signed by authorized Tier 5 Cert Analyzer agents (cloud software with certs signed by the CentCom intermediate CA). Multiple analyzers can run simultaneously for redundancy.

Three CRL tiers provide defense in depth:

- **Normal CRLs** revoke individual node certificates and are signed by a Tier 5 Cert Analyzer.
- **Emergency CRLs** are signed by CentCom (Tier 3, SCIF) and revoke a compromised lower-tier intermediate — for example, a cloud-issuer whose online signing key has been compromised.
- **Deep-emergency CRLs** are signed by the Root CA and revoke a compromised CentCom intermediate. They are the recovery path for CentCom compromise specifically. Root compromise itself is not recoverable through a CRL; it is prevented up front by the air-gapped SCIF and FIPS 140 Level 4 hardware that protect the Root signing infrastructure.

Each block's coinbase carries one informational field for CRL accounting: a SHA-512 hash of the canonical CRL bytes the miner observed at mine-time (`crl_hash`). It is not a consensus rule; blocks are never rejected because of the value of `crl_hash`. It serves as an audit trail visible in block explorers and as a soft signal for offline nodes to detect CRL changes. When no CRL has yet been issued, `crl_hash` is the SHA-512 of the empty string — a canonical placeholder that lets nodes verify the field rather than special-case its absence.

CentCom (Tier 3, SCIF) can add or remove Tier 5 Cert Analyzers via signed gossip commands. If an analyzer is removed (compromise), nodes freeze on CRL updates until they receive one from a remaining valid analyzer. The freeze should be brief since analyzers run 24/7.

## 11. Layer 2 Settlement

Layer 1 is where the Layer 2 superchain settles, and the two are integrated at the consensus level rather than bolted together by an external bridge. Layer 1 understands Layer 2 natively: two dedicated opcodes let an L2 chain register itself and anchor its state directly into L1 blocks, where validators parse and check the structured, signed manifests as part of normal block acceptance. This is a deliberate defense against the single failure mode that has drained more value than any other in crypto — the trusted external bridge. There is no separate bridge contract to compromise; the settlement rules *are* the chain's consensus rules.

**OP_ROLLUP** anchors an L2 batch onto Layer 1. Its output is provably unspendable (never added to the UTXO set) and carries a signed rollup header: the chain identifier, the batch's L2 block range, the before/after state roots and a transaction root, where to fetch the full batch data off-chain, and — critically — two independent ML-DSA-65 signatures. The L2 sequencer signs that it produced the batch; a separate verifier signs that it independently re-executed the batch and reached the same state. The verifier's signature is bound to the specific sequencer claim it attests, so a faulty or fraudulent sequencer cannot get a batch accepted without a second, independent party staking its identity on the same result. A rollup anchor is roughly 9 KB on L1 yet settles an entire batch of hundreds of thousands — even millions — of L2 transactions, because only roots and archive pointers go on-chain.

**OP_REGISTER_CHAIN** is posted once, when an L2 chain is born. It binds the chain's identifier to its initial sequencer certificate and pins the chain's genesis state — which in turn commits to the L2's own governance trust set declared in its genesis manifest (see the L2 white paper). Registration is permanent and **sequencer-signed** — there is no separate registration authority to subvert.

Operator rotation — swapping a chain's active sequencer key, for routine key hygiene or compromise recovery — is handled through the CA and relay layer (PKI), **not a Layer 1 opcode**. This keeps Layer 1 minimal while leaving each chain's governance in control of its own operator changes (see the L2 white paper).

Process signatures (ML-DSA-65, on the L2 manifests) are kept separate from money signatures (Falcon-512, on the L1 inputs that fund the anchors). A stolen sequencer **ML-DSA hot key** is a process-level compromise: it cannot touch user funds, and it cannot by itself forge an accepted state transition, because every rollup also carries an independent verifier's signature. Its worst case is disrupting one chain's anchoring — which the challenge window surfaces and the chain's governance resolves by rotating the key out. A compromised operational key is a contained incident, not a catastrophe.

Each L2 chain anchors on its own schedule — anywhere from minutes to a day or more between rollups, depending on its volume. The full batch data is archived to at least two locations named in the header, and a challenge window (about seven days) lets any party retrieve it, re-execute the batch, and submit proof of fraud. An invalid state transition therefore has to get past both a second independent signer and every watching node — not a single point of trust.

The L2 chains add a second layer of protection — a tiered minting model, on-chain governance, and guardian circuit-breakers that can freeze a compromised token and recover quarantined funds (see the L2 white paper). Together, the two layers are built so the exploits that have repeatedly drained other ecosystems — bridge thefts, unauthorized mints, unrecoverable key compromise — are either impossible or contained by construction.

## 12. Genesis Block and Bitcoin Anchoring

The genesis block is built from a Root-CA-signed genesis configuration file (`genesis-config.json`) containing the network identifier, timestamp, 100 treasury Falcon addresses, and ML-DSA-65 Root CA signatures. The node binary embeds the Root CA verification keys and a valid timestamp range; it verifies the genesis configuration against both before creating the genesis block. A separate Root-CA-signed configuration (`devfund-config.json`) specifies the 7fchain Developer Fund address that receives the 1% coinbase share.

**Multi-signature root model.** Devnet uses a single Root CA. Testnet uses 3 Root CAs with a 2-of-3 quorum; mainnet uses 7 Root CAs with a 4-of-7 quorum. Each Root contributes a separately-signed genesis file (filename keyed off the signer's VK hash); at boot the binary aggregates the files, groups them by canonical-bytes hash, and accepts the genesis only when a quorum of files in one group verifies against the keys in the binary's hardcoded per-tier Root trust list. On mainnet, compromising up to three of the seven Roots still cannot forge a genesis.

The 70,000 7fCOIN genesis allocation is distributed across 100 time-locked outputs of 700 7fCOIN each using `OP_CHECKLOCKTIMEVERIFY`. The first output unlocks at block height 140,000 (≈year 2 at the 7-min target); subsequent outputs unlock every 7,000 blocks thereafter (≈34 days each) for 100 total unlocks, completing at block 833,000 (≈year 11). The mainnet genesis manifest is signed by the 4-of-7 Root CA quorum using ML-DSA-65 and timestamped to the Bitcoin blockchain via OpenTimestamps for independent third-party verifiability.

**Periodic Bitcoin anchoring (planned).** In addition to the genesis block, 7fchain plans to anchor its chain to the Bitcoin blockchain on a periodic basis (approximately daily). Seven Fortunas will post an OpenTimestamps commitment over the current 7fchain L1 tip hash; each commitment lands as a Bitcoin transaction and inherits Bitcoin's proof-of-work security as an external audit anchor, letting any third party independently verify that a specific 7fchain block existed at or before a specific Bitcoin block height — a defense-in-depth check against deep reorgs and a publicly verifiable timestamp that does not depend on trusting 7F's certificate authority. This capability will debut during testnet testing, ahead of mainnet launch, and the block explorer will link directly to the OpenTimestamps proofs for public auditability. The anchoring is informational and does not affect 7fchain consensus rules.

The coinbase carries the founding message: "No meme coins. No spam. No scams. Only utility."

All treasury addresses and their time-lock conditions are publicly verifiable from the first block. The same binary can serve testnet or mainnet by providing different signed genesis configuration files.

## 13. Conclusion

7fchain provides a settlement layer where every cryptographic operation is quantum-resistant from genesis. The certificate-gated network creates accountability without sacrificing openness. The ASIC-resistant proof of work and mining cooldown keep block production distributed among individuals. The deliberately constrained base layer, combined with native Layer 2 support, avoids the scaling debates that have divided other blockchain communities.

The chain is designed to be run by the people who believe in it.

---

*Seven Fortunas, Inc. | US-based | AI-first | Compliance-first | Military-Grade Security*
