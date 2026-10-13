# Run Your Node

This is **step 4** of [Become a miner](become-a-miner.md). It assumes you've run `./setup.sh`, created your wallet and miner identity ([step 2](create-wallet-and-request.md)), and got your certificate with `sf-node obtain` ([step 3](get-a-testnet-certificate.md)).

## 1. Your certificate is already in place

When you ran `sf-node obtain`, the registrar returned your signed certificate **and the chain that validates it**, as one file. **There is nothing for you to copy.** `sf-node obtain` installs it into `~/7fchain/testnet/l1/miner-0/` beside your key, and the network's own certificates are already in `certs/` from `setup.sh`, along with the genesis and dev-fund files.

If you ever need to place one by hand, a returned chain goes in `miner-0/` whole — not split across folders. The node reads the chain from there and the spine from `certs/`.

## 2. Create your node config

```
sf-node init ~/7fchain/testnet/l1
```

This writes `node-config.json`, pointing the node at your `miner-0/` certificate and the `certs/` folder. You only do this once.

## 3. Start the node

```
sf-node start ~/7fchain/testnet/l1/node-config.json
```

Enter your **node-startup password** (the one you set during `sf-node import`). At boot the node verifies your certificate chains to a trusted root, connects to the network's peers, catches up to the current tip, and **then** begins mining. It won't mine until it's synced — if peers aren't reachable yet it waits, which is normal. Blocks you win pay your reward address.

Leave it running to keep mining. Step 4 shows you how to stop it and start it back up.

## 4. Check that it syncs, stops, and starts again

Worth doing once, the first time you run a node. It takes a few minutes and
proves the whole path works before you leave the node to itself.

**Watch it catch up.** As your node pulls the chain it prints a line for each
block it takes:

```
[dispatch] accepted block 1 from 203.0.113.10:8333
[dispatch] accepted block 2 from 203.0.113.10:8333
```

Let it get through a hundred or so. Before those you'll have seen
`[genesis] Genesis block: ...` and `[node] N peer(s) connected` as it came up.
When it reaches the network's current tip it prints:

```
[trusted-tip] OK: local chain == consensus tip
```

and begins mining.

**Stop it.**

```
sf-node stop ~/7fchain/testnet/l1/node-config.json
```

It prints `Stopping sf-node (pid N) - sending SIGTERM...` and then
`sf-node stopped cleanly.` Pressing `Ctrl-C` in the node's own terminal does the
same thing — both take the same clean shutdown, which saves the node's address
book and closes the database properly. Don't use `kill -9`.

**Start it again**, with the same command as step 3. It asks for your
node-startup password again. This is the part worth watching: on a restart the
node rebuilds its state from the database on disk instead of from the network,
which is a different path from a first start. You should see:

```
[genesis] DB genesis matches signed config (...)
Chain reloaded. Height: 137, UTXOs: 412
```

with whatever height you had reached. It then reconnects and carries on from
there — it does not download the chain again. A node that starts, stops, and
starts back up with its height intact has exercised the parts that matter.

## Good to know

- You enter your node-startup password every time you start the node.
- Each certificate can mine a limited number of blocks; when it's used up, get another and switch over with `sf-node rotate --to <N>` — see [Rotate to a new certificate](rotate-your-certificate.md).
- Each identity (`miner-0`, `miner-1`, …) gets its own certificate and payout address; [Rotate to a new certificate](rotate-your-certificate.md) shows how to add one.

## Trouble?

- **"command not found"** — open a new terminal so your `PATH` picks up the programs `setup.sh` installed.
- **Stuck "waiting for a trusted peer"** — the network's peers may be down or unreachable; the node will connect and sync automatically once they're back.
