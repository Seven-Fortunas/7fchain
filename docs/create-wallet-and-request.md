# Create Your Wallet and Miner Request

This is **step 2** of [Become a miner](become-a-miner.md). It assumes you've already downloaded, verified, and run `./setup.sh` - so the programs are installed and your node home exists at `~/7fchain/testnet/l1/`.

You'll set up a few secrets along the way - keep them straight:

| Secret | What it's for |
|---|---|
| **12-word recovery phrase** | Restores *every* key in your wallet. |
| **Wallet passphrase** | Encrypts the wallet file on disk; you enter it to open the wallet. |
| **Node-startup password** | You enter it every time you start the node. |
| **Mining-key password** *(optional)* | Encrypts your block-reward key. |

> **Testnet vs. mainnet - where you run this matters.** On **testnet**, run everything on one ordinary machine and write your recovery phrase on paper - that's the point of practicing. On **mainnet**, run `sf-wallet init` and `sf-wallet csr` on an **air-gapped (never-online) machine**. Then move only what the node needs to your online "hot" node - your encrypted node key (`miner-0/`) and, later, your signed certificate - while your **recovery phrase and your secret reward keys (`airgap-out/`) never leave the air-gapped machine.** Full procedure: [Securing your keys for mainnet](securing-your-keys.md).

> *(If a command says "not found," open a new terminal - `setup.sh` adds the programs to your `PATH`, which a fresh shell picks up.)*

## 1. Go to your node home

```
cd ~/7fchain/testnet/l1
```

Run the next commands from here, so your wallet file is stored alongside the rest of your node.

## 2. Create your wallet

```
sf-wallet init --network testnet
```

- It prints several candidate **12-word recovery phrases** - pick one and **write it on paper.** It controls all your keys; never put it in cloud storage, a screenshot, or a password manager.
- It asks you to set a **wallet passphrase** (separate from the recovery phrase). Write that down too.
- It prints your testnet address (starts with `t1…`).

## 3. Make your miner request

```
sf-wallet csr
```

Enter your **wallet passphrase** to open the wallet, then use the menu **in this order**:

- **3** - Set node-startup password *(required - you'll type this each time the node starts)*
- **4** - Set mining-key password *(recommended; encrypts your reward key)* - or **6** to skip it
- **7** - Generate the request

*(Menu options 1, 2, and 5 are just help text.)*

This writes three things under `~/7fchain/testnet/l1/`:

- `miner-0/` - your node's signing key (the node needs this).
- `csr-out/miner-0/csr.json` - **your request. This is the file you submit** - it's public and safe to share.
- `airgap-out/miner-0/` - your **secret reward keys**. On testnet you can leave them here; **on mainnet these stay on the air-gapped machine** (see the callout above).

**Confirm it worked:**

```
ls csr-out/miner-0/csr.json
```

If that prints the path, you're ready for the next step.

## Next

Buy your **$0.70 testnet certificate** and submit `csr.json` → [step 3 of Become a miner](become-a-miner.md)..