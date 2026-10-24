# Security Policy

Seven Fortunas takes the security of 7fchain and its users seriously. If you find a vulnerability, please tell us privately so we can fix it before anyone can exploit it.

## Report a vulnerability

**Don't open a public issue or discussion for a security problem.** Use either of these instead:

- **GitHub:** [Report a vulnerability](https://github.com/Seven-Fortunas/7fchain/security/advisories/new) privately through this repository.
- **Email:** security@sevenfortunas.com

Please include:

- what's affected (program and release, for example `sf-node 0.2.930 (19237f1)`, or the service's address);
- the steps to reproduce it, or a proof of concept;
- what an attacker could do with it;
- how to reach you, and how you'd like to be credited.

We'll confirm we received your report, keep you updated while we work on it, and agree a disclosure date with you. Please give us a reasonable time to ship a fix before you publish details.

## What's in scope

- The 7fchain programs in the [current release](https://github.com/Seven-Fortunas/7fchain/releases/latest): `sf-node`, `sf-wallet`, `sf-explorer` and the bundled `setup.sh`.
- Consensus, block and transaction validation, peer-to-peer networking and the post-quantum cryptography (ML-DSA-65, ML-KEM-768) as used by those programs.
- Certificate issuance and the certificate chain, including the certificate service at `obtain.sevenfortunas.com`.
- The network explorer at [explore.sevenfortunas.com](https://explore.sevenfortunas.com/).
- Instructions in this repository that would lead a user to expose their keys or lose funds if followed.

## Please don't

- access, change or delete data that isn't yours;
- disrupt the network or other people's nodes (no denial-of-service testing against the live network);
- use social engineering or physical attacks against Seven Fortunas staff or miners;
- test with someone else's keys, API key or certificate.

## Supported versions

Security fixes go into the newest release. Always run the [latest release](https://github.com/Seven-Fortunas/7fchain/releases/latest) and [verify your download](docs/verify-your-download.md) before you run it.
