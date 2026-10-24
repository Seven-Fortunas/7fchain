# Troubleshooting and FAQ

Find the message you see, or your question, below. Messages are shown as the programs print them, without the time each log line starts with; parts in `{braces}` vary. For commands, files and settings, see the [Reference](reference.md).

Still stuck? Ask in [Q&A on GitHub Discussions](https://github.com/Seven-Fortunas/7fchain/discussions/categories/q-a) with the command you ran and the full message. Never post your recovery phrase, passwords, API key or any `.enc` file. Security problems go to security@sevenfortunas.com instead ([SECURITY.md](../SECURITY.md)).

**Jump to:** [Installing](#installing) · [Wallet and identity](#wallet-and-identity) · [Certificates](#certificates) · [Starting the node](#starting-the-node) · [Syncing and peers](#syncing-and-peers) · [Mining](#mining) · [Rewards](#rewards) · [Stopping](#stopping) · [FAQ](#faq)

## Installing

### `command not found` for `sf-node`, `sf-wallet` or `sf-explorer`

On Linux or WSL, open a new terminal so it picks up the `PATH` that `setup.sh` set. On macOS, run `echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.zshrc` once, then open a new terminal.

### `no 7fchain release is built for {OS}/{ARCH}`

7fchain runs on 64-bit Linux (x86_64 or aarch64). On Windows, use [WSL](install-wsl.md).

### `cannot execute binary file: Exec format error`

You downloaded the archive for another platform. Check `uname -sm` against the table in [Update your miner](update-your-miner.md#1-download-the-new-release) and download the right one.

### ``version `GLIBC_2.34' not found``

Your Linux is too old for this release. It needs Ubuntu 22.04, Debian 12 or newer.

### `… bundle looks incomplete.`

The archive didn't unpack fully. Download it again, [verify it](verify-your-download.md), and unpack it with `tar xzf`.

### `FAILED` when verifying the download

Don't run it. Delete the archive and download it again. More in [Verify your download](verify-your-download.md).

## Wallet and identity

### `No wallet found at: …`

Run `cd ~/7fchain/testnet/l1` first, then the command again.

### `Failed to load wallet DB: decryption failed …`

Wrong wallet passphrase: the one you set in `sf-wallet init`.

### `Wallet DB already exists at: …`

You already have a wallet in this folder. Use it; `sf-wallet init` doesn't replace it.

### `Not under a 7fchain/<net>/<l1|l2> directory, so the network can't be inferred.`

Run `cd ~/7fchain/testnet/l1` first, then the command again.

### `Miner {n} was already exported:`

That identity exists. Continue with `sf-node import airgap-out/miner-{n}/transport.json`. To create another identity, use `sf-wallet miner-export --miner-index {next number}`.

### `could not open {path}. A wrong transport password and a damaged blob look the same here …`

Almost always a mistyped transport password: run `sf-node import` again and type the one you set in `sf-wallet miner-export`.

### `miner {n} already has a key at {path}`

This identity is already imported. There's nothing to do. Add `--force` only if you mean to replace it.

### I forgot my boot password.

Import the identity again and set a new one: `sf-node import airgap-out/miner-0/transport.json --force`. You need the transport password for that. Forgot that too? On the wallet machine, `sf-wallet miner-export --miner-index 0 --force` writes the same identity again with a new transport password.

## Certificates

### `pass --key <api-key> or set SF_OBTAIN_KEY`

Your API key isn't loaded in this terminal. Load it in the same terminal you run `sf-node obtain` from (see [Get a testnet certificate](get-a-testnet-certificate.md)).

### `HTTP 401 … unknown API key`

The key was mistyped. Load it again and paste it carefully.

### `HTTP 429 … quota {used}/{max}`

Your key has used its certificate allowance, or you asked for more certificates than it has left. Try a smaller `--count`, or ask the person who invited you for more. Your node's first `obtain` also uses one certificate, for its session certificate.

### `HTTP 429 … rate limit`

Too many requests in a minute. Wait a minute and run it again.

### `GET {url}: …` or `POST {url}: …`

Your machine couldn't reach the registrar at `obtain.sevenfortunas.com`. Check your internet connection and run it again.

### `no miner identity under {dir} to obtain a certificate for.`

Import your identity first: `sf-node import airgap-out/miner-0/transport.json`.

### `Failed to decrypt {keyfile}: …`

Wrong boot password: it's the one you set during `sf-node import`.

### `refusing to install: … a different certificate for the same key`

Nothing was installed. Post the full message in [Q&A](https://github.com/Seven-Fortunas/7fchain/discussions/categories/q-a).

### My certificate is used up, or `sf-node certs` says `exhausted`.

Run `sf-node obtain --count 1`. The running node picks the new certificate up as the network adds blocks, without a restart. See [When your certificates run out](get-a-testnet-certificate.md#when-your-certificates-run-out).

### `sf-node certs` shows `? of {n}` and status `?`.

That's expected while the node runs: the node has the chain open, so `certs` can't count blocks. Stop the node and run `sf-node certs` again to see the counts. While mining, the log line `[miner] cert serial {s}: {used}/{allowed} blocks mined, {left} left …` shows the same numbers.

## Starting the node

### `node-config.json not found at {path}.` or `Failed to load config from {path}: …`

Run `sf-node init` once, then start again.

### `Failed to decrypt ML-DSA key: decryption failed: wrong password or corrupted keyfile`

Wrong boot password: it's the one you set during `sf-node import`.

### `No miner identity is staged under {dir} …`

Import your identity (`sf-node import airgap-out/miner-0/transport.json`) and get a certificate (`sf-node obtain --count 1`).

### `[boot] miner-{n} ({dir}) is not usable: {problem}`

| `{problem}` | Fix |
|---|---|
| `no ml-dsa-hot.key.enc` | Import that identity with `sf-node import` |
| `no miner chain (*.pem)` | Get its certificate: `sf-node obtain --count 1` (add `--keyfile miner-{n}/ml-dsa-hot.key.enc` for an identity other than the one you mine with) |
| `no chain here certifies this directory's hot key (cert/key mismatch)` | The certificate in that folder belongs to another identity. Move it out and run `obtain` with `--keyfile` naming this identity's key |

### `[boot] miner_index is {n} but nothing usable is staged at that index …`

Switch to an identity that's ready, `sf-node rotate --to 0`, or finish setting up identity `{n}` ([Rotate your certificate](rotate-your-certificate.md)).

### `[node] FATAL: a miner certificate is staged … but its chain won't assemble`

Usually a certificate from before a testnet restart. Follow steps 6 and 7 of [Update your miner](update-your-miner.md): move `miner-*/miner-cert-*.pem` aside and run `sf-node obtain --count 1`. If the message says a file `holds {n} certificates`, that file comes from an older release: move it aside the same way.

### `[node] FATAL: … this node has a miner chain but no session_x509_chain`

Run `sf-node obtain --count 1` with your API key loaded; it also gets the node's session certificate. Then start again. If `obtain` says `session chain already at {path}`, run `sf-node init` (it records that file in your config, and resets any settings you changed by hand) and start again.

### `[node] FATAL: the cert this node presents is not for its hot key …`

Your `session-chain.pem` belongs to another identity, usually after `sf-node rotate`. Follow step 2 of [Rotate your certificate](rotate-your-certificate.md#2-get-its-certificate): move it aside and run `sf-node obtain` for the identity you mine with.

### `[node] FATAL: this node has no usable certificate spine.`

The network's certificates in `certs/` are missing. Run `./setup.sh` again from the release folder; it puts them back.

### `[genesis] FATAL: genesis MISMATCH … This DB belongs to a different genesis`

Your chain is from before a testnet restart. Run `./setup.sh --clean` from the new release folder ([Update your miner](update-your-miner.md)).

### `failed to start listener`, `failed to start RPC listener` or `failed to open block store`

Another node is already running with this home or these ports. Find it with `pgrep -l sf-node`. Stop it with `Ctrl-C` in its terminal, or with `kill <pid>`, which is the same clean shutdown (never `kill -9`). Then start again. `sf-node stop` may report a stale pid file here, because the start that failed replaced it.

## Syncing and peers

### My node stays at height 496

Releases before `testnet-2026-10-22` can't read block 497. Install the new release with plain `./setup.sh` ([Update your miner](update-your-miner.md)): your chain is kept and syncs on from 496.

### `[trusted-tip] no trusted peer found — node is up and waiting for a trusted peer to appear …`

This machine can't look up the network's hubs, `node01` to `node07.sevenfortunas.com`. Check your internet connection and DNS. The node checks again every 30 seconds and syncs as soon as it finds them.

### `[trusted-tip] waiting for trusted peer to connect (my height {h})`

The hubs' names were found, but no connection has been made yet. Check that this machine can make outgoing connections on port 7788 (some office, school and hotel networks block it). The node keeps trying and syncs as soon as it connects.

### `[node] failed to connect to onion peer …`

Tor isn't running on this machine, so onion addresses can't be reached. Start Tor ([Tor guide](tor-for-your-node.md)). The hubs don't need Tor.

### `[trusted-tip] syncing — my height {h}, trusted max {m} (gap {g})`

Normal: your node is downloading the chain. It starts mining after a line beginning `[trusted-tip] OK:`.

### `[trusted-tip] could not resolve trusted peer node03.sevenfortunas.com:7788 at boot …`

Normal, one line each for `node03` to `node07`. At every start the node looks up all seven network hubs; node01 and node02 are the ones in service, and one reachable hub is enough.

### `[trusted-tip] our height {h} is AHEAD of trusted peer max {m} — proceeding …`

Normal at the end of a sync: your node took the newest block a moment before the hub reported it. The next line is `[trusted-tip] OK:`.

### `… EXCEEDS auto-reorg cap … RESTART THE NODE to apply it`

Your node went down a different branch of the chain. Start it again: it rolls back and resyncs by itself, printing `Chain rolled back to height {h}; resyncing from there.`

## Mining

### How do I know my node is mining?

After a line beginning `[trusted-tip] OK:`, it prints `[miner] mining block {h}...`. When it wins one: `[miner] FOUND block {h}!`, then `[miner] block {h} stored.` Your blocks show on the [Miners page](https://explore.sevenfortunas.com/miners) under your payout address.

### `[miner] our cert is within the last {n} block(s) of the tip — in cooldown …`

Normal. After your block, the next one has to come from another miner. Your node resumes by itself (`cooldown released — resuming mining`).

### `[miner] our certificate mined the tip and is spent — holding …`

That was your certificate's last block. Run `sf-node obtain --count 1`; the node starts on the new certificate as other miners add blocks, without a restart.

### `[miner] no usable miner certificate under {dir} — mining STOPPED.`

Run `sf-node obtain --count 1`. The node picks the new certificate up at the next network block, without a restart.

### `[miner] every certificate at miner-{a} is used up. miner-{b} has a usable one …`

Run `sf-node rotate --to {b}`, then restart the node. First follow step 2 of [Rotate your certificate](rotate-your-certificate.md#2-get-its-certificate), so the node has a session certificate for that identity.

### `sf-node certs` says `not yet valid`, or `[miner] our block {h} rejected by validator: block timestamp …`

Your computer's clock is wrong. Turn on automatic date and time, then restart the node.

### `[miner] 0 peers connected — waiting for at least one before mining`

See [Syncing and peers](#syncing-and-peers): the node mines once it's connected.

### `[mining-schedule] no slot covers current time — sleeping`

Your mining schedule has no window for this time. Check it with `sf-node mining`; `sf-node mining reset` mines all day.

### `[miner] our block {h} stored on fork (peer block won)`

Another miner's block for the same height reached the network first. It happens; your node carries on with the next block.

### I've been mining for a while and haven't won a block.

Blocks come about every 7 minutes for the whole network, and many miners compete for each one. Check that the node is synced (`[trusted-tip] OK`) and that `sf-node certs` lists a `usable` certificate (stop the node to see it). Then give it time.

## Rewards

### How do I see my rewards?

With the node running, run `sf-wallet balance --miner 0` from `~/7fchain/testnet/l1`. Or run `sf-node getaddrbalance <your payout address>`, or look up the address on [explore.sevenfortunas.com](https://explore.sevenfortunas.com/).

### `… coinbase output(s) worth {sats} sats are held back: not spendable until height {h} …`

Mining rewards can be spent 20 blocks after the block that earned them. Wait until the chain reaches height `{h}`.

### `Failed RPC to {node}: …`

`sf-wallet` talks to your node: start the node, then run the command again.

### Why is my reward a little under 7 7fCOIN?

You receive 99% of each block's reward and fees; 1% goes to the development fund.

## Stopping

### `No running node found (no {pid_path}). Nothing to stop.`

The node isn't running, so there's nothing to do. If you think one is running, check with `pgrep -l sf-node`.

### `Node pid {pid} is not running (stale pid file) — removing {path}.`

The node had already stopped without cleaning up; `stop` tidied up for you.

### `sf-node (pid {pid}) did not exit within 30s — it may still be shutting down …`

Give it a little longer: it's saving its state. Check with `pgrep -l sf-node`.

## FAQ

### Does testnet 7fCOIN have value?

No. Testnet is for running real miners with nothing of value at stake.

### Is testnet different software from mainnet?

No. Mainnet runs the same software and protocol values, with its own nine Root key holders.

### Does my computer need to stay on?

Your node mines only while it runs. To mine only at certain hours, set a window with `sf-node mining` ([Reference](reference.md#sf-node-commands)).

### Do I need to open a port on my router?

No. Outgoing connections are enough to sync and mine. To let other nodes reach yours, publish an onion address ([Tor guide](tor-for-your-node.md)).

### Where's the log?

In the terminal running the node. To keep a copy, start it with `sf-node start 2>&1 | tee -ia ~/7fchain/testnet/l1/node.log` (the `-i` keeps `Ctrl-C` working).

### Can I run more than one identity?

Yes. Each identity has its own certificates and payout address; your node mines with one at a time. See [Rotate your certificate](rotate-your-certificate.md).

### Can I move my node to another machine?

Yes. Stop the node, copy `~/7fchain` across, install the same release with `./setup.sh`, then run `sf-node init` there, which updates the paths in your config (add `--miner-index N` if you mine with an identity other than 0; re-add any peers or onion address you set by hand), and start the node. Never run the same identity on two machines at once.

### Can I start over?

Use `./setup.sh --clean`: it restarts the chain and keeps your wallet and keys. **Never delete `~/7fchain`**, which holds them.

### How do I update to a new release?

Follow [Update your miner](update-your-miner.md).

---

Back to [Docs](README.md) · [Reference](reference.md)
