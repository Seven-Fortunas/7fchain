# Buy a Testnet Certificate ($0.70)

This is **step 3** of [Become a miner](become-a-miner.md). It assumes you've already created your wallet and miner request ([step 2](create-wallet-and-request.md)), so you have a `csr.json` file ready.

A certificate is what grants your node an identity on the network. The registrar verifies your request and issues a certificate signed by a trusted intermediate CA - your node checks this chain against the root key built into `sf-node` before it will mine.

## What you need before you start

- Your miner request file: `~/7fchain/testnet/l1/csr-out/miner-0/csr.json`
- A wallet with **0.70 USDC on Base mainnet** (live now), or wait for Stripe (coming soon)

## Go to the certificate store

**[certstore.sevenfortunas.com](https://certstore.sevenfortunas.com)**

The store walks you through submitting your `csr.json` and completing payment. It runs in your browser - no account needed.

## Payment options

| Method | Status | Notes |
|--------|--------|-------|
| **USDC on Base** | Live | 0.70 USDC on Base mainnet - MetaMask or Coinbase Wallet |
| USDC on Optimism | Coming soon | - |
| Credit / debit card (Stripe) | Coming soon | No crypto wallet needed |
| 7F Token | Coming soon | Discounted rate for holders |

**For Base USDC:** the payment uses EIP-3009 `transferWithAuthorization` - one signature in your wallet, no separate approval transaction.

## What you receive

After payment the registrar automatically returns **two things**:

1. **Your miner certificate** - the signed credential for your node
2. **The certificate chain** - the intermediate CA certificates that connect your cert to the trusted root

Both need to be in place before `sf-node` will start.

## Put the files in place

The certificate store shows the exact filenames and copy-paste commands after purchase. In general:

- your certificate goes in `~/7fchain/testnet/l1/miner-0/`
- the chain files go in `~/7fchain/testnet/l1/intermediate-certs/`

The `intermediate-certs/` directory was created empty by `setup.sh` - this is where the chain goes.

## Certificate validity

Each testnet certificate is valid for **up to 214 days** and covers a fixed number of mined blocks. When it's used up or expires, return to the store for a new one (use `--miner-index 1` for a fresh node identity).

## Next

→ **[Run your node](run-your-node.md)**
