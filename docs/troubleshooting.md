# Troubleshooting and FAQ

Find the message you see, or your question, below. Messages are shown as the programs print them, without the time each log line starts with; parts in `{braces}` vary. For commands, files and settings, see the [Reference](reference.md).

Still stuck? Ask in [Q&A on GitHub Discussions](https://github.com/Seven-Fortunas/7fchain/discussions/categories/q-a) with the command you ran and the full message. Never post your recovery phrase, passwords, API key or any `.enc` file. Security problems go to security@sevenfortunas.com instead ([SECURITY.md](../SECURITY.md)).

**Jump to:** [Installing](#installing) · [Wallet and identity](#wallet-and-identity) · [Certificates](#certificates) · [Starting the node](#starting-the-node) · [Syncing and peers](#syncing-and-peers) · [Mining](#mining) · [Rewards](#rewards) · [Stopping](#stopping) · [FAQ](#faq)

## Installing

<details>
<summary><code>command not found</code> for <code>sf-node</code>, <code>sf-wallet</code> or <code>sf-explorer</code></summary>

On Linux or WSL, open a new terminal so it picks up the `PATH` that `setup.sh` set. On macOS, run `echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.zshrc` once, then open a new terminal.

</details>

<details>
<summary><code>no 7fchain release is built for {OS}/{ARCH}</code></summary>

7fchain runs on 64-bit Linux (x86_64 or aarch64). On Windows, use [WSL](install-wsl.md).

</details>

<details>
<summary><code>cannot execute binary file: Exec format error</code></summary>

You downloaded the archive for another platform. Check `uname -sm` against the table in [Update your miner](update-your-miner.md#1-download-the-new-release) and download the right one.

</details>

<details>
<summary><code>version `GLIBC_2.34' not found</code></summary>

Your Linux is too old for this release. It needs Ubuntu 22.04, Debian 12 or newer.

</details>

<details>
<summary><code>… bundle looks incomplete.</code></summary>

The archive didn't unpack fully. Download it again, [verify it](verify-your-download.md), and unpack it with `tar xzf`.

</details>

<details>
<summary><code>FAILED</code> when verifying the download</summary>

Don't run it. Delete the archive and download it again. More in [Verify your download](verify-your-download.md).

</details>

## Wallet and identity

<details>
<summary><code>No wallet found at: …</code></summary>

Run `cd ~/7fchain/testnet/l1` first, then the command again.

</details>

<details>
<summary><code>Failed to load wallet DB: decryption failed …</code></summary>

Wrong wallet passphrase: the one you set in `sf-wallet init`.

</details>

<details>
<summary><code>Wallet DB already exists at: …</code></summary>

You already have a wallet in this folder. Use it; `sf-wallet init` doesn't replace it.

</details>

<details>
<summary><code>Not under a 7fchain/&lt;net&gt;/&lt;l1|l2&gt; directory, so the network can't be inferred.</code></summary>

Run `cd ~/7fchain/testnet/l1` first, then the command again.

</details>

<details>
<summary><code>Miner {n} was already exported:</code></summary>

That identity exists. Continue with `sf-node import airgap-out/miner-{n}/transport.json`. To create another identity, use `sf-wallet miner-export --miner-index {next number}`.

</details>

<details>
<summary><code>could not open {path}. A wrong transport password and a damaged blob look the same here …</code></summary>

Almost always a mistyped transport password: run `sf-node import` again and type the one you set in `sf-wallet miner-export`.

</details>

<details>
<summary><code>miner {n} already has a key at {path}</code></summary>

This identity is already imported. There's nothing to do. Add `--force` only if you mean to replace it.

</details>

<details>
<summary>I forgot my boot password.</summary>

Import the identity again and set a new one: `sf-node import airgap-out/miner-0/transport.json --force`. You need the transport password for that. Forgot that too? On the wallet machine, `sf-wallet miner-export --miner-index 0 --force` writes the same identity again with a new transport password.

</details>

## Certificates

<details>
<summary><code>pass --key &lt;api-key&gt; or set SF_OBTAIN_KEY</code></summary>

Your API key isn't loaded in this terminal. Load it in the same terminal you run `sf-node obtain` from (see [Get a testnet certificate](get-a-testnet-certificate.md)).

</details>

<details>
<summary><code>HTTP 401 … unknown API key</code></summary>

The key was mistyped. Load it again and paste it carefully.

</details>

<details>
<summary><code>HTTP 429 … quota {used}/{max}</code></summary>

Your key has used its certificate allowance, or you asked for more certificates than it has left. Try a smaller `--count`, or ask the person who invited you for more. Your node's first `obtain` also uses one certificate, for its session certificate.

</details>

<details>
<summary><code>HTTP 429 … rate limit</code></summary>

Too many requests in a minute. Wait a minute and run it again.

</details>

<details>
<summary><code>GET {url}: …</code> or <code>POST {url}: …</code></summary>

Your machine couldn't reach the registrar at `obtain.sevenfortunas.com`. Check your internet connection and run it again.

</details>

<details>
<summary><code>no miner identity under {dir} to obtain a certificate for.</code></summary>

Import your identity first: `sf-node import airgap-out/miner-0/transport.json`.

</details>

<details>
<summary><code>Failed to decrypt {keyfile}: …</code></summary>

Wrong boot password: it's the one you set during `sf-node import`.

</details>

<details>
<summary><code>refusing to install: … a different certificate for the same key</code></summary>

Nothing was installed. Post the full message in [Q&A](https://github.com/Seven-Fortunas/7fchain/discussions/categories/q-a).

</details>

<details>
<summary>My certificate is used up, or <code>sf-node certs</code> says <code>exhausted</code>.</summary>

Run `sf-node obtain --count 1`. The running node picks the new certificate up as the network adds blocks, without a restart. See [When your certificates run out](get-a-testnet-certificate.md#when-your-certificates-run-out).

</details>

<details>
<summary><code>sf-node certs</code> shows <code>? of {n}</code> and status <code>?</code>.</summary>

That's expected while the node runs: the node has the chain open, so `certs` can't count blocks. Stop the node and run `sf-node certs` again to see the counts. While mining, the log line `[miner] cert serial {s}: {used}/{allowed} blocks mined, {left} left …` shows the same numbers.

</details>

## Starting the node

<details>
<summary><code>node-config.json not found at {path}.</code> or <code>Failed to load config from {path}: …</code></summary>

Run `sf-node init` once, then start again.

</details>

<details>
<summary><code>Failed to decrypt ML-DSA key: decryption failed: wrong password or corrupted keyfile</code></summary>

Wrong boot password: it's the one you set during `sf-node import`.

</details>

<details>
<summary><code>No miner identity is staged under {dir} …</code></summary>

Import your identity (`sf-node import airgap-out/miner-0/transport.json`) and get a certificate (`sf-node obtain --count 1`).

</details>

<details>
<summary><code>[boot] miner-{n} ({dir}) is not usable: {problem}</code></summary>

| `{problem}` | Fix |
|---|---|
| `no ml-dsa-hot.key.enc` | Import that identity with `sf-node import` |
| `no miner chain (*.pem)` | Get its certificate: `sf-node obtain --count 1` (add `--keyfile miner-{n}/ml-dsa-hot.key.enc` for an identity other than the one you mine with) |
| `no chain here certifies this directory's hot key (cert/key mismatch)` | The certificate in that folder belongs to another identity. Move it out and run `obtain` with `--keyfile` naming this identity's key |

</details>

<details>
<summary><code>[boot] miner_index is {n} but nothing usable is staged at that index …</code></summary>

Switch to an identity that's ready, `sf-node rotate --to 0`, or finish setting up identity `{n}` ([Rotate your certificate](rotate-your-certificate.md)).

</details>

<details>
<summary><code>[node] FATAL: a miner certificate is staged … but its chain won't assemble</code></summary>

Usually a certificate from before a testnet restart. Follow steps 6 and 7 of [Update your miner](update-your-miner.md): move `miner-*/miner-cert-*.pem` aside and run `sf-node obtain --count 1`. If the message says a file `holds {n} certificates`, that file comes from an older release: move it aside the same way.

</details>

<details>
<summary><code>[node] FATAL: … this node has a miner chain but no session_x509_chain</code></summary>

Run `sf-node obtain --count 1` with your API key loaded; it also gets the node's session certificate. Then start again. If `obtain` says `session chain already at {path}`, run `sf-node init` (it records that file in your config, and resets any settings you changed by hand) and start again.

</details>

<details>
<summary><code>[node] FATAL: the cert this node presents is not for its hot key …</code></summary>

Your `session-chain.pem` belongs to another identity, usually after `sf-node rotate`. Follow step 2 of [Rotate your certificate](rotate-your-certificate.md#2-get-its-certificate): move it aside and run `sf-node obtain` for the identity you mine with.

</details>

<details>
<summary><code>[node] FATAL: this node has no usable certificate spine.</code></summary>

The network's certificates in `certs/` are missing. Run `./setup.sh` again from the release folder; it puts them back.

</details>

<details>
<summary><code>[genesis] FATAL: genesis MISMATCH … This DB belongs to a different genesis</code></summary>

Your chain is from before a testnet restart. Run `./setup.sh --clean` from the new release folder ([Update your miner](update-your-miner.md)).

</details>

<details>
<summary><code>failed to start listener</code>, <code>failed to start RPC listener</code> or <code>failed to open block store</code></summary>

Another node is already running with this home or these ports. Find it with `pgrep -l sf-node`. Stop it with `Ctrl-C` in its terminal, or with `kill <pid>`, which is the same clean shutdown (never `kill -9`). Then start again. `sf-node stop` may report a stale pid file here, because the start that failed replaced it.

</details>

## Syncing and peers

<details>
<summary>My node stays at height 496</summary>

Releases before `testnet-2026-10-22` can't read block 497. Install the new release with plain `./setup.sh` ([Update your miner](update-your-miner.md)): your chain is kept and syncs on from 496.

</details>

<details>
<summary><code>[trusted-tip] no trusted peer found — node is up and waiting for a trusted peer to appear …</code></summary>

This machine can't look up the network's hubs, `node01` to `node07.sevenfortunas.com`. Check your internet connection and DNS. The node checks again every 30 seconds and syncs as soon as it finds them.

</details>

<details>
<summary><code>[trusted-tip] waiting for trusted peer to connect (my height {h})</code></summary>

The hubs' names were found, but no connection has been made yet. Check that this machine can make outgoing connections on port 7788 (some office, school and hotel networks block it). The node keeps trying and syncs as soon as it connects.

</details>

<details>
<summary><code>[node] failed to connect to onion peer …</code></summary>

Tor isn't running on this machine, so onion addresses can't be reached. Start Tor ([Tor guide](tor-for-your-node.md)). The hubs don't need Tor.

</details>

<details>
<summary><code>[trusted-tip] syncing — my height {h}, trusted max {m} (gap {g})</code></summary>

Normal: your node is downloading the chain. It starts mining after a line beginning `[trusted-tip] OK:`.

</details>

<details>
<summary><code>[trusted-tip] could not resolve trusted peer node03.sevenfortunas.com:7788 at boot …</code></summary>

Normal, one line each for `node03` to `node07`. At every start the node looks up all seven network hubs; node01 and node02 are the ones in service, and one reachable hub is enough.

</details>

<details>
<summary><code>[trusted-tip] our height {h} is AHEAD of trusted peer max {m} — proceeding …</code></summary>

Normal at the end of a sync: your node took the newest block a moment before the hub reported it. The next line is `[trusted-tip] OK:`.

</details>

<details>
<summary><code>… EXCEEDS auto-reorg cap … RESTART THE NODE to apply it</code></summary>

Your node went down a different branch of the chain. Start it again: it rolls back and resyncs by itself, printing `Chain rolled back to height {h}; resyncing from there.`

</details>

## Mining

<details>
<summary>How do I know my node is mining?</summary>

After a line beginning `[trusted-tip] OK:`, it prints `[miner] mining block {h}...`. When it wins one: `[miner] FOUND block {h}!`, then `[miner] block {h} stored.` Your blocks show on the [Miners page](https://explore.sevenfortunas.com/miners) under your payout address.

</details>

<details>
<summary><code>[miner] our cert is within the last {n} block(s) of the tip — in cooldown …</code></summary>

Normal. After your block, the next one has to come from another miner. Your node resumes by itself (`cooldown released — resuming mining`).

</details>

<details>
<summary><code>[miner] our certificate mined the tip and is spent — holding …</code></summary>

That was your certificate's last block. Run `sf-node obtain --count 1`; the node starts on the new certificate as other miners add blocks, without a restart.

</details>

<details>
<summary><code>[miner] no usable miner certificate under {dir} — mining STOPPED.</code></summary>

Run `sf-node obtain --count 1`. The node picks the new certificate up at the next network block, without a restart.

</details>

<details>
<summary><code>[miner] every certificate at miner-{a} is used up. miner-{b} has a usable one …</code></summary>

Run `sf-node rotate --to {b}`, then restart the node. First follow step 2 of [Rotate your certificate](rotate-your-certificate.md#2-get-its-certificate), so the node has a session certificate for that identity.

</details>

<details>
<summary><code>sf-node certs</code> says <code>not yet valid</code>, or <code>[miner] our block {h} rejected by validator: block timestamp …</code></summary>

Your computer's clock is wrong. Turn on automatic date and time, then restart the node.

</details>

<details>
<summary><code>[miner] 0 peers connected — waiting for at least one before mining</code></summary>

See [Syncing and peers](#syncing-and-peers): the node mines once it's connected.

</details>

<details>
<summary><code>[mining-schedule] no slot covers current time — sleeping</code></summary>

Your mining schedule has no window for this time. Check it with `sf-node mining`; `sf-node mining reset` mines all day.

</details>

<details>
<summary><code>[miner] our block {h} stored on fork (peer block won)</code></summary>

Another miner's block for the same height reached the network first. It happens; your node carries on with the next block.

</details>

<details>
<summary>I've been mining for a while and haven't won a block.</summary>

Blocks come about every 7 minutes for the whole network, and many miners compete for each one. Check that the node is synced (`[trusted-tip] OK`) and that `sf-node certs` lists a `usable` certificate (stop the node to see it). Then give it time.

</details>

## Rewards

<details>
<summary>How do I see my rewards?</summary>

With the node running, run `sf-wallet balance --miner 0` from `~/7fchain/testnet/l1`. Or run `sf-node getaddrbalance <your payout address>`, or look up the address on [explore.sevenfortunas.com](https://explore.sevenfortunas.com/).

</details>

<details>
<summary><code>… coinbase output(s) worth {sats} sats are held back: not spendable until height {h} …</code></summary>

Mining rewards can be spent 20 blocks after the block that earned them. Wait until the chain reaches height `{h}`.

</details>

<details>
<summary><code>Failed RPC to {node}: …</code></summary>

`sf-wallet` talks to your node: start the node, then run the command again.

</details>

<details>
<summary>Why is my reward a little under 7 7fCOIN?</summary>

You receive 99% of each block's reward and fees; 1% goes to the development fund.

</details>

## Stopping

<details>
<summary><code>No running node found (no {pid_path}). Nothing to stop.</code></summary>

The node isn't running, so there's nothing to do. If you think one is running, check with `pgrep -l sf-node`.

</details>

<details>
<summary><code>Node pid {pid} is not running (stale pid file) — removing {path}.</code></summary>

The node had already stopped without cleaning up; `stop` tidied up for you.

</details>

<details>
<summary><code>sf-node (pid {pid}) did not exit within 30s — it may still be shutting down …</code></summary>

Give it a little longer: it's saving its state. Check with `pgrep -l sf-node`.

</details>

## FAQ

<details>
<summary>Does testnet 7fCOIN have value?</summary>

No. Testnet is for running real miners with nothing of value at stake.

</details>

<details>
<summary>Is testnet different software from mainnet?</summary>

No. Mainnet runs the same software and protocol values, with its own nine Root key holders.

</details>

<details>
<summary>Does my computer need to stay on?</summary>

Your node mines only while it runs. To mine only at certain hours, set a window with `sf-node mining` ([Reference](reference.md#sf-node-commands)).

</details>

<details>
<summary>Do I need to open a port on my router?</summary>

No. Outgoing connections are enough to sync and mine. To let other nodes reach yours, publish an onion address ([Tor guide](tor-for-your-node.md)).

</details>

<details>
<summary>Where's the log?</summary>

In the terminal running the node. To keep a copy, start it with `sf-node start 2>&1 | tee -ia ~/7fchain/testnet/l1/node.log` (the `-i` keeps `Ctrl-C` working).

</details>

<details>
<summary>Can I run more than one identity?</summary>

Yes. Each identity has its own certificates and payout address; your node mines with one at a time. See [Rotate your certificate](rotate-your-certificate.md).

</details>

<details>
<summary>Can I move my node to another machine?</summary>

Yes. Stop the node and copy `~/7fchain` directly between your own machines (a USB drive or `scp`), never through cloud storage, email or chat; then delete the old copy. On the new machine, install the same release with `./setup.sh`, then run `sf-node init` there, which updates the paths in your config (add `--miner-index N` if you mine with an identity other than 0; re-add any peers or onion address you set by hand), and start the node. Never run the same identity on two machines at once.

</details>

<details>
<summary>Can I start over?</summary>

Use `./setup.sh --clean`: it restarts the chain and keeps your wallet and keys. **Never delete `~/7fchain`**, which holds them.

</details>

<details>
<summary>How do I update to a new release?</summary>

Follow [Update your miner](update-your-miner.md).

</details>

---

Back to [Docs](README.md) · [Reference](reference.md)
