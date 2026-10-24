# Reference

The commands, files, settings and network numbers a testnet miner uses, on one page. For step-by-step setup, follow [Become a miner](become-a-miner.md). When something goes wrong, see [Troubleshooting and FAQ](troubleshooting.md).

Everything here matches release `testnet-2026-10-22` (`sf-node 0.2.930 (19237f1)`).

## The programs

`./setup.sh` installs three programs into `~/.local/bin`:

| Program | What it does |
|---|---|
| `sf-node` | Runs your node: syncs the chain, mines, and gets and manages your certificates |
| `sf-wallet` | Your wallet: recovery phrase, miner identities, balances and payments |
| `sf-explorer` | A block explorer in your browser, reading from your own node ([guide](run-an-explorer.md)) |

Each one prints its version with `--version` and its full usage with `--help`.

## sf-node commands

Run these from your node home, `~/7fchain/testnet/l1`: paths such as `airgap-out/…` and `miner-1/…` are relative to it. Commands that take a node home or a config default to `~/7fchain/testnet/l1` and its `node-config.json`.

| Command | What it does |
|---|---|
| `sf-node import airgap-out/miner-0/transport.json` | Imports a miner identity made by `sf-wallet miner-export` and asks you to set the **boot password**. Add `--force` to replace an identity already imported at that number |
| `sf-node obtain --count 1` | Gets a miner certificate from the registrar and installs it. Needs your API key (see [environment variables](#environment-variables)). `--count K` gets K certificates at once. `--keyfile miner-1/ml-dsa-hot.key.enc` gets one for a different identity |
| `sf-node init` | Writes `node-config.json`. Run it once; running it again replaces the file, including any settings you changed by hand. `--miner-index N` sets which identity mines |
| `sf-node start` | Starts the node in this terminal and asks for your boot password (the prompt says `ML-DSA keyfile password`) |
| `sf-node stop` | Stops a running node cleanly (the same as `Ctrl-C` in its terminal) |
| `sf-node certs` | Lists your certificates: serial, blocks left, expiry and status (`usable`, `not yet valid`, `expired`, `exhausted`). While the node runs, blocks left shows `?`: stop the node to see the counts |
| `sf-node rotate --to N` | Switches mining to identity `miner-N`, then you restart the node ([guide](rotate-your-certificate.md)) |
| `sf-node peers` | Shows the peers you added. `peers add <host:port>`, `peers remove <host:port>` and `peers clear` change the list. The network's hubs are always used and don't need adding, even when this list is empty (`sf-node peers` then says no peers will be dialed; the hubs are dialed anyway) |
| `sf-node mining` | Shows when your node mines; by default, all day. To mine only from 22:00 to 07:00 (local time), run `sf-node mining remove 0`, then `sf-node mining add 22:00-07:00 background`. `mining reset` returns to all day. Restart the node to apply a change |
| `sf-node getaddrbalance <t1… address>` | Shows the balance of any address, using your running node |

## sf-wallet commands a miner uses

Run these from `~/7fchain/testnet/l1`, where your wallet file `wallet.db.enc` lives. Each asks for your wallet passphrase.

| Command | What it does |
|---|---|
| `sf-wallet init` | Creates your wallet and its 24-word recovery phrase ([guide](create-wallet-and-request.md)). `--import` restores one from an existing phrase |
| `sf-wallet miner-export` | Creates miner identity 0 and writes it to `airgap-out/miner-0/`. `--miner-index N` creates identity N |
| `sf-wallet miner-info --index N` | Prints the payout address of identity N |
| `sf-wallet balance` | Shows every balance in the wallet, including your mining rewards. `--miner 0` shows identity 0 only. Needs your node running |
| `sf-wallet send` | Sends coins. With no options it opens a menu. `--from-miner 0 --to <address> --amount <coins>` (or `--max`) spends identity 0's rewards. Needs your node running |
| `sf-wallet list-addresses` | Lists your wallet's addresses |

## sf-explorer

```
sf-explorer --network testnet --node 127.0.0.1:7735 --listen 127.0.0.1:8080
```

Then open `http://127.0.0.1:8080`. Full guide: [Run your own explorer](run-an-explorer.md).

## Files in your node home

Your node home is `~/7fchain/testnet/l1`.

| Path | What it holds | Keep it private? |
|---|---|---|
| `wallet.db.enc` | Your wallet, encrypted with your wallet passphrase | **Yes** |
| `airgap-out/miner-N/transport.json` | Identity N's node key, encrypted with the transport password, for `sf-node import` | **Yes** |
| `airgap-out/miner-N/ml-dsa-payout.key.enc` | The key that **spends** identity N's rewards (`ml-dsa-payout.key.json`, unencrypted, if you skipped the mining-key password) | **Yes** |
| `miner-N/ml-dsa-hot.key.enc` | Identity N's node key, encrypted with your boot password | **Yes** |
| `miner-N/miner-cert-*.pem` | Identity N's certificates, one per file | No |
| `imported/miner-N/payout.json` | Identity N's payout address | No |
| `certs/` | The network's certificates and your registrar's certificate | No |
| `session-chain.pem` | The certificate your node shows other nodes | No |
| `node-config.json` | Your node's settings | No |
| `genesis-config.json`, `devfund-config.json` | The network definition, signed by the Root key holders | No |
| `blocks.redb` | The chain. Your node can always download it again | No |
| `peers.json` | Addresses of other nodes your node has learned | No |
| `mining-schedule.json` | When your node mines (`sf-node mining`) | No |
| `mempool.dat` | Transactions waiting for a block, saved at shutdown | No |
| `sf-node.pid` | The running node's process number; removed when it stops | No |
| `inbox/`, `outbox/` | Certificate requests and replies from `sf-node obtain` | No |

On a computer other people can log in to, run `chmod -R go-rwx ~/7fchain` after setup, so only your user can read these files.

**Never delete `~/7fchain`.** It holds your wallet and keys. `./setup.sh --clean` is the safe way to start the chain over: it removes the chain, the peer list, the mining schedule, the network files and the old programs, and keeps your wallet, keys, identities, certificates and `node-config.json`.

## Settings in node-config.json

Edit these with the node stopped, then start it again.

| Setting | Testnet value | What it does |
|---|---|---|
| `listen_port` | `7788` | Port for connections from other nodes |
| `rpc_port` | `7735` | Local port for `sf-wallet`, `sf-explorer` and `getaddrbalance` |
| `rpc_bind` | `127.0.0.1` | Keeps that port to this machine. Leave it: the RPC has no password, so opening it lets anyone who can reach it use your node |
| `mining` | `true` | `false` runs the node without mining |
| `miner_index` | `0` | Which identity mines; `sf-node rotate` sets it |
| `seed_peers` | `[]` | Extra peers; `sf-node peers add` sets it |
| `advertised_onion` | `null` | Your onion address, so other nodes can reach you ([Tor guide](tor-for-your-node.md)) |
| `tor_socks_proxy` | `127.0.0.1:9050` | The Tor proxy used to reach onion addresses |

## Network numbers

| | Testnet |
|---|---|
| Peer port | 7788. Outgoing connections to the hubs on this port are all a node needs |
| Local RPC port | 7735 |
| Network hubs | `node01` to `node07.sevenfortunas.com`, port 7788; one reachable hub is enough |
| Target time between blocks | 7 minutes |
| Block reward | 7 7fCOIN, reduced by 7% every 70,000 blocks, with a floor of 0.07 |
| Your share | 99% of the reward and fees; 1% goes to the development fund |
| Rewards spendable after | 20 blocks |
| Cooldown | After a certificate mines a block, it waits for a block from another miner before it mines again. The network lengthens the wait as more miners join |
| Blocks per certificate | Set in each certificate; `sf-node certs` shows it |
| Address prefix | `t1` (mainnet addresses start with `7f`) |
| Root key quorum | 6 of 9 |

Mainnet uses peer port 7777 and RPC port 7737, with its own nine Root key holders; everything else is the same.

## Environment variables

| Variable | Used by | What it holds |
|---|---|---|
| `SF_OBTAIN_KEY` | `sf-node obtain` | Your API key, instead of `--key`. Load it without showing it: `printf 'API key: '; read -rs SF_OBTAIN_KEY; echo; export SF_OBTAIN_KEY`, and `unset SF_OBTAIN_KEY` afterwards |

Every password is asked for at a prompt, which is the safest way to enter it.

## Logs

`sf-node start` prints its log to the terminal it runs in. To keep a copy as well:

```
sf-node start 2>&1 | tee -ia ~/7fchain/testnet/l1/node.log
```

Keep the `-i`: it lets `Ctrl-C` reach the node for a clean shutdown.

---

Back to [Docs](README.md) · [Troubleshooting and FAQ](troubleshooting.md)
