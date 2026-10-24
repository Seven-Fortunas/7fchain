# Rotate to a New Certificate

**Most miners never need this page.** When a certificate's blocks run out, the usual fix is to get another for the identity you already mine with: `sf-node obtain --count 1`, and the running node picks it up without a restart. See [When your certificates run out](get-a-testnet-certificate.md#when-your-certificates-run-out).

**Rotation** moves your node onto a *different identity*, with its own key, certificates and payout address. Use it to start a new identity, to recover if a certificate is ever revoked, or to switch between identities you've already set up. It takes three steps.

> **Your coins are safe.** Rotating changes your node's *identity*, not your wallet. Coins already paid to your reward address stay yours no matter what happens to the certificate that earned them. A new identity gets its own reward address; both keep paying out.

## Before you start

You can prepare the new identity **before** you need it. Then its certificate is sitting ready and rotation takes seconds.

Identities are numbered: your first is `miner-0`, your next is `miner-1`, then `miner-2`, and so on. Pick the next unused number and use it everywhere below. These examples use **1**.

## 1. Create the new identity

From your node home (`cd ~/7fchain/testnet/l1`):

```
sf-wallet miner-export --miner-index 1
sf-node import airgap-out/miner-1/transport.json
```

Same wallet, same recovery phrase — this derives a brand-new identity from it, so there's nothing new to back up. The menu and the passwords are the same as the first time ([step 2](create-wallet-and-request.md)); the boot password can be the one you already use. You end up with:

- `miner-1/` — the key your node will use
- `imported/miner-1/` — its payout address (a new one; your first keeps paying out too)
- `airgap-out/miner-1/` — the key that spends this identity's rewards, for cold storage

## 2. Get its certificate

With your API key loaded as in [Get a testnet certificate](get-a-testnet-certificate.md):

```
mv session-chain.pem session-chain-miner-0.pem
sf-node obtain --count 1 --keyfile miner-1/ml-dsa-hot.key.enc
```

The first line moves your current session certificate aside. It belongs to `miner-0`, and a node whose session certificate doesn't match the key it mines with won't start. `obtain` then gets a new one for `miner-1` along with its certificate, which uses one more certificate from your allowance.

Name the key file: without it, `obtain` asks for a certificate for the identity your node is mining on now. The certificate installs itself into `miner-1/` (the certificates that signed it are already in `certs/`) — nothing to copy.

## 3. Switch the node over

```
sf-node rotate --to 1
```

That's it. This changes one setting in your config, `miner_index`, and leaves everything else — your peers, your mining schedule, your ports — exactly as it was.

It checks the new identity is complete before changing anything: the folder exists, the keys are there, and the certificate actually matches the key. If something's missing it tells you what and **changes nothing**, so a half-finished rotation can't leave your node unable to start.

Then restart:

```
sf-node stop  ~/7fchain/testnet/l1/node-config.json
sf-node start ~/7fchain/testnet/l1/node-config.json
```

Your node comes back up on the new certificate and starts mining again.

## Switching back

Rotation isn't one-way. Every identity you've set up stays on disk, so `sf-node rotate --to 0` returns you to your first one, once you swap the session certificates back:

```
mv session-chain.pem session-chain-miner-1.pem
mv session-chain-miner-0.pem session-chain.pem
sf-node rotate --to 0
```

Then restart the node. This is only useful if that identity's certificate still has blocks left.

## Trouble?

Every `rotate refused` message says what's missing; steps 1 and 2 above fix it.

- **"rotate refused: no usable certificate at miner-1 … Staged: …"** — nothing usable is set up under that number. `Staged:` lists the identities that are. Run steps 1 and 2 for the number you're rotating to.
- **"rotate refused: miner-1 is staged but unusable: no ml-dsa-hot.key.enc"** — step 1 hasn't been completed for this identity: run the `sf-node import` line.
- **"… unusable: no miner chain (\*.pem)"** — step 2 hasn't been run for this identity yet.
- **"… unusable: no chain here certifies this directory's hot key (cert/key mismatch)"** — the certificate in `miner-1/` belongs to a different identity. Re-run step 2 with `--keyfile` naming this identity's key.
- **Node still won't mine after restarting** — it needs to sync to the current tip first, which is normal. If it says it's waiting for a trusted peer, the network's peers will pick it up automatically.

---

Back to [Become a miner](become-a-miner.md) · [Run your node](run-your-node.md)
