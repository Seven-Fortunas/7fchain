# Make your node reachable over Tor

This is **step 5** of [Become a miner](become-a-miner.md), and it is optional.
Skip it and your node still syncs, mines, and earns — nothing here is required.
You can come back and do it later without changing anything else about your setup.

## What this gets you, and what it does not

Your node dials out to the network's hubs and keeps up with the chain that way.
What it cannot do, on an ordinary home connection, is accept a connection coming
*in*: your router gives your machine a private address, so there is nothing for
another node to dial. Every home miner is in the same position, which is why no
two home miners reach each other directly today — they all talk through the hubs.

Publishing a Tor v3 onion service gives your node an address other nodes can
dial. You do not have to forward a port on your router, pay for a static IP, or
expose your home IP address.

Be clear on the limits:

- **It does not hide the chain.** Blocks and transactions are public by design.
  There is nothing in them to conceal.
- **Your node's identity is already post-quantum, with or without Tor.** Peers
  prove who they are with ML-DSA certificates and agree session keys with
  ML-KEM-768, so the link between two nodes is post-quantum either way. Tor's own
  encryption is classical. What Tor adds here is an inbound route and privacy
  about where your node is — not confidentiality of what it sends.
- **Nobody finds you automatically yet.** Peer-address gossip is not built, so
  you share your address with another operator and they add it to their
  configuration. Automatic discovery is planned.

## 1. Install Tor

On Debian, Ubuntu, or WSL:

```
sudo apt install tor
```

The SOCKS5 proxy your node dials out through runs on `127.0.0.1:9050` by
default, which is exactly where your node already looks for it. There is nothing
to configure for outbound connections.

## 2. Publish a hidden service

Find your node's `listen_port` in `~/7fchain/testnet/l1/node-config.json`. Then
edit `/etc/tor/torrc` and add the following, using that same port in both places
on the last line:

```
HiddenServiceDir /var/lib/tor/7fchain/
HiddenServiceVersion 3
HiddenServicePort <listen_port> 127.0.0.1:<listen_port>
```

## 3. Restart Tor and read your address

```
sudo systemctl restart tor
sudo cat /var/lib/tor/7fchain/hostname
```

That prints a 56-character address ending in `.onion`. Tor generated the key
itself and keeps it in that folder; back the folder up if you want to keep the
same address after rebuilding the machine.

## 4. Record your address in your config (optional)

In `~/7fchain/testnet/l1/node-config.json`, set `advertised_onion` to your
address followed by your `listen_port`:

```
"advertised_onion": "<your-56-char-address>.onion:<listen_port>"
```

This is how your node will offer itself to other nodes once address gossip
ships. **It has no effect today**, and leaving it unset costs you nothing — your
node still peers normally, still dials other onion addresses, and still accepts
inbound onion connections from anyone you hand the address to. Set it now if you
would rather not revisit the file later.

## 5. Give your address to someone

Send your `.onion` address to an operator you want to peer with, over any
channel you trust. They add `"<your-address>.onion:<listen_port>"` to
`seed_peers` in their own `node-config.json` and restart.

Leave your own `seed_peers` alone. The hubs already listed there are how your
node syncs the chain, and removing them would cut you off.

Restart your node and carry on with [Become a miner](become-a-miner.md).

---

Back to [Become a miner](become-a-miner.md) · [Run your node](run-your-node.md)
