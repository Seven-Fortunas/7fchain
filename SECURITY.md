# Security Policy

If you find a vulnerability in 7fchain, tell us privately so we can fix it before anyone exploits it.

## Report a vulnerability

**Don't open a public issue or discussion for a security problem.** Use either of these instead:

- **GitHub:** [Report a vulnerability](https://github.com/Seven-Fortunas/7fchain/security/advisories/new) privately through this repository.
- **Email:** security@sevenfortunas.com

Please include:

- what's affected (program and release, for example `sf-node 0.2.930 (19237f1)`, or the service's address);
- the steps to reproduce it, or a proof of concept;
- what an attacker could do with it;
- how to reach you, and how you'd like to be credited.

We'll confirm we received it within three business days, keep you updated while we fix it, and agree on a disclosure date with you.

## What's in scope

- The 7fchain programs in the [current release](https://github.com/Seven-Fortunas/7fchain/releases/latest): `sf-node`, `sf-wallet`, `sf-explorer` and the bundled `setup.sh`.
- Consensus, block and transaction validation, peer-to-peer networking and the post-quantum cryptography (ML-DSA-65, ML-KEM-768) as used by those programs.
- Certificate issuance and the certificate chain, including the certificate service at `obtain.sevenfortunas.com`.
- The network explorer at [explore.sevenfortunas.com](https://explore.sevenfortunas.com/).
- Instructions in this repository that would lead a user to expose their keys or lose funds if followed.

## Safe harbor

We treat good-faith research under this policy as authorized, and we won't take legal action against you for it. Good faith means you:

- test only with your own keys, API key, certificates and nodes, and stop as soon as you reach anything that isn't yours;
- don't disrupt the network or other people's nodes: no denial-of-service testing against the live network (run your own nodes for that);
- keep the details private until the agreed disclosure date.

Social engineering, phishing and physical attacks against our people or miners are never authorized.

## We will never ask for your secrets

Nobody from Seven Fortunas will ever ask for your recovery phrase, passwords, API key or `.enc` key files, by email, in Discussions or anywhere else. Anyone who does is not us: report it to security@sevenfortunas.com.

## Supported versions

Security fixes go into the newest release. Always run the [latest release](https://github.com/Seven-Fortunas/7fchain/releases/latest) and [verify your download](docs/verify-your-download.md) before you run it.
