# Docs

Step-by-step guides for testnet miners. If you're just getting started, follow them in order.

## Start here: miner onboarding

| Step | Guide | When you need it |
|------|-------|-----------------|
| Overview | [Become a miner](become-a-miner.md) | Read this first - the whole flow on one page |
| 1. Download | [Verify your download](verify-your-download.md) | After downloading the release bundle |
| 2. Wallet | [Create your wallet & miner identity](create-wallet-and-request.md) | After running `./setup.sh` |
| 3. Certificate | [Get a testnet certificate](get-a-testnet-certificate.md) | After importing your identity - free, needs your invitation API key |
| 4. Node | [Run your node](run-your-node.md) | After `sf-node obtain` has installed your certificate |
| 5. Tor | [Make your node reachable over Tor](tor-for-your-node.md) | Optional - lets other nodes reach yours |
| 6. Explorer | [Run your own explorer](run-an-explorer.md) | Optional - watch the chain in a browser |
| 7. Rotate | [Rotate to a new certificate](rotate-your-certificate.md) | When a certificate's blocks run out |

## Situational guides

| Guide | When to read it |
|-------|----------------|
| [Update your miner](update-your-miner.md) | Already mining - install a new release over your node (and what to do after a testnet restart) |
| [Install WSL (Windows)](install-wsl.md) | Windows users only - install Ubuntu before step 1 |
| [Securing your keys for mainnet](securing-your-keys.md) | Before mainnet launch - not needed for testnet practice |

## Background reading

For the full design behind what these tools do, see the [papers](../papers/).
