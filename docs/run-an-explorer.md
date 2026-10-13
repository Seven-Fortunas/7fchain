# Run Your Own Block Explorer (Optional)

`sf-explorer` is a local, read-only block explorer — a web view of the chain (blocks, transactions, addresses) that runs on your own machine. It ships in the same release bundle as `sf-node` and `sf-wallet`, so there's nothing extra to download.

You don't need it to mine. It's a nice way to watch your node and the network.

## Run it

Make sure your node is running first (see [Run your node](run-your-node.md)) — the explorer reads from it. Then, in a second terminal:

```
sf-explorer --network testnet --node 127.0.0.1:7735
```

- `--network testnet` — the network to display.
- `--node 127.0.0.1:7735` — your local node's testnet RPC address.

Then open **http://localhost:8080** in your browser.

## Good to know

- It's **read-only** — the explorer never touches your keys or your wallet.
- It only shows what your node knows; if your node is still catching up, the explorer reflects that.
- Stop it with `Ctrl-C`; your node keeps running independently.
