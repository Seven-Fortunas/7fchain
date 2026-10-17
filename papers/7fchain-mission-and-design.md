**Seven Fortunas, Inc.**

---

# Why 7fchain Exists

*A non-technical companion to the 7fchain Layer 1 white paper.*

---

## 1. Why does 7fchain exist?

Most blockchain projects open with technology — throughput, market cap, network effects. We open with the people we are building for: workers in the United States sending money home to family in Latin America, and the family receiving it. Seven Fortunas is building 7fchain to help working people, beginning with the Americas. Everything that follows in this document exists in service of that goal.

Those transfers have historically cost five to ten percent. Stablecoins have started bringing that down. Our aim is to bring it to zero. Even at today's rates, tens of billions of dollars per year are extracted by intermediation across the Americas — banks, money-transfer networks, currency conversion, wire fees compounded across hops — and the workers paying those fees often have the least margin to absorb them.

A blockchain alone does not solve that problem. The right blockchain, the right Layer 2, and the right on-the-ground partnerships — with the businesses families actually live alongside — can.

Our long-term work happens at the L2 — a fast, cheap transaction layer, first for the Americas, and then for any region with the same need, where remittance is one important use case among many. Stable-money primitives, small-business payments, settlement between AI agents and their owners, and anything else that needs frequent low-fee movement of value live here. Gas fees are paid in 7fUSD, a utility token held to a low, stable band, so costs are predictable and there is no need to hold a volatile native token to use the network.

But credible L2 financial infrastructure cannot be built on a Layer 1 that is exposed to quantum, controlled by a handful of mining pools, or run by a foundation that enriches itself first. So we built our own L1 — reluctantly, and deliberately. The Layer 1 exists to anchor the Layer 2. The Layer 2 is where the mission gets real.

## 2. Why not just use Bitcoin?

Bitcoin is the obvious answer to most of what 7fchain is trying to do. We hold it, we use it, and we owe Satoshi the entire shape of what we are trying to build — decentralization, sound money, public verifiability. None of that started with us.

**The quantum risk.** A sufficiently powerful quantum computer breaks the cryptography that secures Bitcoin. NIST finalized the post-quantum replacements in 2024; federal migration timelines are accelerating. The first coins to fall are the roughly one million in pay-to-public-key (P2PK) addresses, where the public key is already fully exposed on-chain. Other Bitcoin addresses only leak their public keys when they spend, but every spend opens a window. Migrating Bitcoin to post-quantum signatures is possible in principle, but retrofitting a chain this large is hard, slow, and contentious.

**The funding risk.** Bitcoin has no built-in funding for ongoing development. The work is paid for by a small set of companies and donors, each with their own commercial priorities. When those priorities clash with the broader community's view of what Bitcoin is for — as they did during the block size wars, and as they have more recently around OP_RETURN expansion — the people writing the code can be pulled in directions a large fraction of holders would not have chosen. The protocol does not provide for itself; the people maintaining it have to be paid by someone, and "someone" has interests.

**The block-reward risk.** Bitcoin pays its miners with newly issued coins. That issuance halves every four years and stops entirely some decades from now. After that, miners have to be paid by transaction fees alone — a model that has not yet been tested at the scale Bitcoin will eventually need. Mining today is already concentrated in a small number of pools whose business depends on subsidies that are shrinking. A chain that anchors global remittance flows needs a reward model that does not eventually starve its security budget.

None of this is a critique of Bitcoin. Bitcoin is trustless; 7fchain is not. The certificate authority that gates participation is a trust assumption Bitcoin does not require, and we are explicit about that. What the trust does not extend to is history: every 7fchain block hash is written to Bitcoin through OpenTimestamps, so anyone can verify that a block existed at a given Bitcoin block height without trusting Seven Fortunas. We accept the trade-off in exchange for what the L2 use case needs: predictable security funding, throughput suited to everyday transfers, and post-quantum cryptography across both layers from the first block. 7fchain is designing its Layer 1 and Layer 2 to be post-quantum end to end. We are not building a better Bitcoin. We are building something different.

## 3. Why not just use Ethereum or Solana?

Ethereum and Solana have shipped real innovation. Ethereum's rollups, account abstraction, and developer ecosystem are core infrastructure for programmable money. Solana's throughput hits numbers Bitcoin and Ethereum cannot match. We respect both, and we are not trying to compete with either. They solve different problems than we are, and they made different trade-offs to get there. We considered each as the Layer 1 anchor for our L2 and chose against both, for two reasons.

The first is quantum, and the answer is worse than Bitcoin's. Ethereum and Solana rely on elliptic-curve cryptography across the whole protocol — wallet signatures, validator identities, smart-contract addresses. Where Bitcoin has roughly a million coins permanently exposed in old P2PK addresses and the rest of the network exposed only at spend time, Ethereum and Solana addresses leak their public keys on every interaction. The same quantum computer that breaks Bitcoin breaks them harder, and they have more on-chain value to lose when it does. Both projects have started discussing post-quantum migration. Neither has shipped one. The ecosystem and tooling lock-in that makes them powerful today is what will make migration slow and contentious when it happens.

The second is how their tokens were distributed at launch. Ethereum's 2014 launch allocated a substantial fraction of its initial supply to founders, the Ethereum Foundation, and early purchasers before working software existed. Solana's pre-mine put roughly 36 to 40 percent of initial supply in the hands of insiders, the foundation, and early investors, on vesting schedules whose unlock dynamics were not fully transparent at launch. Both projects have produced real technical innovation from those starting positions, and both have made early holders extraordinarily wealthy. We are not casting that as villainous — early-stage projects need capital. But it is not the model we want for a chain whose mission is to put more of every dollar into the hands of the people who earn it. We made a different choice: no premine, no founder or investor allocation and no token sale. Apart from one ordinary block reward that the genesis block pays to the development fund, every 7fCOIN is mined.

None of this is a critique of Ethereum or Solana. They have different histories, different missions, and different communities. We are not trying to replace them. We are trying to build the specific thing that has to exist for working-class L2 infrastructure to be trustworthy for the long term.

## 4. What's actually different about how 7fchain is built?

Four design choices, each addressing a specific gap we saw in Bitcoin or Ethereum, and each carrying its own trade-offs.

**Post-quantum from the first block.** Every signature on 7fchain is ML-DSA-65 (NIST FIPS 204) — transactions, certificates, all of it. One algorithm, nothing to migrate later. There is no ECDSA on the chain. Address formats, transaction layouts, and network protocols all account for post-quantum signature sizes from genesis. We never need a contentious migration, because we never relied on cryptography that a quantum computer is going to break.

**CPU-mineable, by design.** Mining uses RandomX — the same proof of work Monero adopted to break ASIC dominance. RandomX is built for general-purpose CPUs. Specialized hardware can still be built for it, but its edge is small. The realistic per-machine hashpower spread between a high-end server and a commodity laptop is about fifty times. Compare that to Bitcoin, where industrial ASIC farms are vastly faster than any consumer device. On 7fchain, anyone with an old laptop or a twenty-dollar-per-month rented virtual server has a meaningful chance of mining a block.

**Cooldown-rotating mining.** Every miner's certificate has a per-block cooldown: after producing a block, that certificate is forbidden from producing another for several blocks. The cooldown adapts as the active community grows — small at launch, larger when the network has thousands of operators. This forces rotation. Even an operator with significantly more hashpower can earn at most one block per cooldown window. Rewards distribute across the active mining community rather than concentrating in pools.

**Certificate-gated, partner-distributed.** Mining requires a post-quantum certificate issued by the 7fchain certificate authority under a published 7F Foundation policy. Certificates are not sold from one central store: they are distributed through a network of up to 700 regional partners, each allocated a bounded number per period within its own territory. Testnet certificates are free and by invitation; mainnet terms will be published. Each certificate is valid for about seven months and can produce at most 10 blocks in its lifetime (the protocol never allows more than 50), and each registrar can issue at most 200. An attacker who wants ten percent of network rewards has to obtain ten percent of the certificates, one at a time, under the issuance policy, and no single partner or region can accumulate enough of them to dominate block production. Combined with the per-certificate cooldown, there is no Sybil shortcut: concentration is designed out of the distribution layer, not policed after the fact.

These four choices interact. Post-quantum cryptography keeps the chain secure as quantum hardware improves. CPU-mineability keeps the operator base broad. Cooldown rotation keeps reward distribution fair across that operator base. Capped, partner-distributed certificates keep the operator base honest and geographically spread. Each choice on its own would be defensible. Together they make a chain that is intentionally harder to centralize, harder to capture, and harder to break — at the cost of the trustless property Bitcoin has and we do not.

## 5. Who is this for?

Three audiences, with very different experiences of the same chain.

**The working person.** Someone in the United States sending money home, or a family member in Latin America receiving it — and, increasingly, the same story in other corridors worldwide. They never see the chain. They see a wallet on their phone, a balance, and money that moves quickly and cheaply between the two. Gas paid in 7fUSD, held to a low, stable band, means they always know what something will cost. Settlement to the Layer 1 happens in the background. The point of every technical choice in this document is that this person can ignore them all.

**The operator.** Someone running a node — mining, relaying, or both. They need a certificate (free and by invitation on testnet; mainnet terms will be published), a wallet, and a Linux or macOS machine that can be as small as a twenty-dollar-per-month rented server. There are no staking minimums, no GPU requirements, no specialized hardware. The cooldown rule means even small operators earn a fair share of rewards, not just the largest. The same person can run their node on a refurbished laptop in their living room and have a meaningful expected return at the early phase of the chain.

**The investor or partner.** Someone evaluating Seven Fortunas for capital, partnership, or alignment. They see founder economics designed to pay out only as the community succeeds, a token supply tighter than Bitcoin's, and a Layer 2 designed to compress the fee a working family pays toward zero. They see a team that names what we do not yet have answers for and ships against a public roadmap. They see infrastructure work, not a token launch.

These three audiences need very different things from us. The working person needs the system to be invisible and reliable. The operator needs participation to be cheap and fair. The investor needs to know our success is gated on the community's. We have tried to design for all three, in that order.

## 6. What's the realistic path from here?

Testnet launched in 2026 and is producing blocks. Seven Fortunas is among the early miners, alongside a small founding cohort. The testnet is open to additional operators worldwide, with a target of 70 distinct miners.

Mainnet launches once testnet has produced blocks from 70 different miners, with December 2026 as the goal. The condition comes first and the date second: it is a participation milestone. We are not interested in announcing a "mainnet launch date" and then watching the chain run for years on a handful of mining hosts in one region. The 70-distinct-miner threshold is the test that the chain has the geographic and operator diversity it needs to credibly secure the Layer 2 networks built on top.

The Layer 2 work is advancing in parallel with Layer 1, not after it. The first corridors are remittance-focused — the US-to-Latin-America flows that started this project — but the same rails serve any region that needs cheap, stable, fast settlement, and we are in active conversations with partners and companies across the Americas, Europe, Africa, and Asia. Consumer phone apps, stable-money primitives, agent-registry infrastructure for AI agents authorized by their human principals, and small-business payment rails all run on the Layer 2.

What we are explicitly not promising: a token launch in the financial sense, a price target, a "100x" return, a fixed mainnet date, or any specific outcome for early holders. 7fCOIN exists to pay miners and to denominate value on the chain — not as a speculative instrument. If you are joining the project as an investor, partner, or operator because you believe in the mission and the design, we welcome you. If you are joining for a near-term moonshot, you should look elsewhere.

---

*Seven Fortunas, Inc. | US-based | AI-first | Compliance-first | Military-Grade Security*
