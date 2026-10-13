# Rotate to a New Certificate

Every certificate mines a limited number of blocks over its life. When yours is used up, your node stops winning blocks — you don't lose anything, you just need to move it onto a fresh certificate. That's **rotation**, and it takes three steps.

Rotation is also how you recover if a certificate is ever revoked, and how you switch between identities you've already set up.

> **Your coins are safe.** Rotating changes your node's *identity*, not your wallet. Coins already paid to your reward address stay yours no matter what happens to the certificate that earned them. A new identity gets its own reward address; both keep paying out.

## Before you start

You can prepare a replacement **before** the current one runs out — that's the smooth way to do it, because the new certificate is sitting ready and rotation takes seconds. Nothing stops you from staging several in advance.

Identities are numbered: your first is `miner-0`, your next is `miner-1`, then `miner-2`, and so on. Pick the next unused number and use it everywhere below. These examples use **1**.

## 1. Create the new identity

From your node home (`cd ~/7fchain/testnet/l1`):

```
sf-wallet miner-export --miner-index 1
sf-node import airgap-out/miner-1/transport.json
```

Same wallet, same recovery phrase — this derives a brand-new identity from it, so there's nothing new to back up. The menu and the passwords are the same as the first time ([step 2](create-wallet-and-request.md)); the node-startup password can be the one you already use. You end up with:

- `miner-1/` — the key your node will use
- `imported/miner-1/` — its payout address (a new one; your first keeps paying out too)
- `airgap-out/miner-1/` — the key that spends this identity's rewards, for cold storage

## 2. Get its certificate

With your API key loaded as in [Get a testnet certificate](get-a-testnet-certificate.md):

```
sf-node obtain --count 1 --keyfile miner-1/ml-dsa-hot.key.enc
```

Name the key file: without it, `obtain` asks for a certificate for the identity your node is mining on now. The certificate and its chain install themselves into `miner-1/` — nothing to copy.

## 3. Switch the node over

```
sf-node rotate --to 1
```

That's it. This edits only the three identity settings in your config and leaves everything else — your peers, your mining schedule, your ports — exactly as it was.

It checks the new identity is complete before changing anything: the folder exists, the keys are there, and the certificate actually matches the key. If something's missing it tells you what and **changes nothing**, so a half-finished rotation can't leave your node unable to start.

Then restart:

```
sf-node stop  ~/7fchain/testnet/l1/node-config.json
sf-node start ~/7fchain/testnet/l1/node-config.json
```

Your node comes back up on the new certificate and starts mining again.

## Switching back

Rotation isn't one-way. Every identity you've set up stays on disk, so `sf-node rotate --to 0` returns you to your first one. Only useful if that certificate still has blocks left, but the door's open.

## Trouble?

- **"rotate refused: identity dir … does not exist"** — step 1 hasn't been run for that number, or you used a different `--miner-index` than you're rotating to.
- **"rotate refused: no miner certificate in …"** — step 2 hasn't been run for this identity yet.
- **"rotate refused: none of the miner-cert(s) … match the ml-dsa key"** — that certificate belongs to a different identity. Re-run step 2 with `--keyfile` naming this identity's key.
- **Node still won't mine after restarting** — it needs to sync to the current tip first, which is normal. If it says it's waiting for a trusted peer, the network's peers will pick it up automatically.

---

Back to [Become a miner](become-a-miner.md) · [Run your node](run-your-node.md)
