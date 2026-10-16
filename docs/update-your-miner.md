# Update Your Miner

For miners who already run a 7fchain node and want the new release. New miners: follow [Become a miner](become-a-miner.md) instead.

> **The current release is `testnet-2026-10-16.1`, and the testnet restarted from block 1 with it.** If you mined with `testnet-2026-10-11` or earlier, your old chain and certificates no longer work. Follow every step below, including steps 6 and 7. Your wallet and keys are kept.

All commands run on your node machine. Your node home is `~/7fchain/testnet/l1`.

## 1. Download the new release

Pick your platform (`uname -sm` tells you which):

| `uname -sm` prints | Platform |
|---|---|
| `Linux x86_64` | `x86_64-linux` |
| `Linux aarch64` | `aarch64-linux` |
| `Darwin arm64` | `arm64-macos` |
| `Darwin x86_64` | `x86_64-macos` |

Then download the archive and the checksum file into a new folder (set `PLATFORM` to yours):

```
REL=testnet-2026-10-16.1
PLATFORM=x86_64-linux
mkdir -p ~/7fchain-releases/$REL && cd ~/7fchain-releases/$REL
curl -fLO https://github.com/Seven-Fortunas/7fchain/releases/download/$REL/7fchain-$REL-$PLATFORM.tar.gz
curl -fLO https://github.com/Seven-Fortunas/7fchain/releases/download/$REL/SHA256SUMS
```

You can also download both files from the [Releases page](https://github.com/Seven-Fortunas/7fchain/releases/latest) in your browser.

## 2. Verify it

On Linux:

```
grep $PLATFORM.tar.gz SHA256SUMS | sha256sum -c
```

On macOS:

```
grep $PLATFORM.tar.gz SHA256SUMS | shasum -a 256 -c
```

You should see your archive's name followed by **`OK`**. If it says `FAILED`, do not run it: delete it and download again. More detail: [Verify your download](verify-your-download.md).

## 3. Stop your node

```
sf-node stop ~/7fchain/testnet/l1/node-config.json
```

It prints `sf-node stopped cleanly.` If the node wasn't running, it says so; carry on.

## 4. Run the new setup

```
tar xzf 7fchain-$REL-$PLATFORM.tar.gz
cd 7fchain-$REL-$PLATFORM
./setup.sh --clean
```

`--clean` is needed whenever the release notes say the testnet **restarted**, as it did for `testnet-2026-10-16.1`. It replaces the programs and the network files and clears the chain database and peer list; your node downloads the new chain again. It **keeps** your wallet, keys, `miner-0/`, `node-config.json` and the registrar certificate in `certs/`.

For a release that did not restart the testnet, plain `./setup.sh` is enough: it replaces the programs and keeps everything else, chain included.

## 5. Check the version

```
sf-node --version
```

For `testnet-2026-10-16.1` it prints:

```
sf-node 0.2.1 (04f254e)
```

## 6. Move your old certificates aside (testnet restart only)

Certificates from before the restart no longer work, and a node that finds one refuses to start. Move them out of `miner-0/`:

```
cd ~/7fchain/testnet/l1
mkdir -p ~/7fchain/old-certs
mv miner-*/miner-cert-*.pem ~/7fchain/old-certs/
```

This moves certificate files only. Your keys stay where they are.

## 7. Get new certificates (testnet restart only)

Your API key's allowance was reset for the restart. In the same terminal, load your key (nothing is shown as you type) and get a certificate:

```
cd ~/7fchain/testnet/l1
printf 'API key: '; read -rs SF_OBTAIN_KEY; echo; export SF_OBTAIN_KEY
sf-node obtain --count 1
```

Enter your **node-startup password** when asked. You should see `installed miner-0/ ...` and `wrote session chain .../session-chain.pem`; the new session chain replaces the old one. When you're done, run `unset SF_OBTAIN_KEY`. Details and error messages: [Get a testnet certificate](get-a-testnet-certificate.md).

## 8. Start your node

```
sf-node start ~/7fchain/testnet/l1/node-config.json
```

Enter your node-startup password. After a restart release the node downloads the chain from block 1, printing a line for each block:

```
[dispatch] accepted block 1 from 203.0.113.10:8333
```

When it reaches the network's tip it prints `[trusted-tip] OK: local chain == consensus tip` and starts mining. Compare its height with the network's at [explore.sevenfortunas.com](https://explore.sevenfortunas.com/).

More on running, stopping and restarting: [Run your node](run-your-node.md).

---

**Never delete `~/7fchain` to "start fresh".** It holds your wallet and keys. `./setup.sh --clean` is the safe way to start the chain over.
