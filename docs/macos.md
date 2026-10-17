# 7fchain on macOS

7fchain runs natively on Macs with Apple silicon (M1 and later) and with Intel processors. Follow [Become a miner](become-a-miner.md) as everyone does; this page collects the Mac-specific details in one place.

## Which download

Open **Terminal** (in Applications → Utilities) and run:

```
uname -sm
```

| It prints | Your platform |
|---|---|
| `Darwin arm64` | `arm64-macos` (Apple silicon) |
| `Darwin x86_64` | `x86_64-macos` (Intel) |

## Download in Terminal

Downloading with `curl` in Terminal is the simplest route on a Mac: macOS runs the programs straight away. Set `PLATFORM` to yours:

```
REL=testnet-2026-10-16.2
PLATFORM=arm64-macos
mkdir -p ~/7fchain-releases/$REL && cd ~/7fchain-releases/$REL
curl -fLO https://github.com/Seven-Fortunas/7fchain/releases/download/$REL/7fchain-$REL-$PLATFORM.tar.gz
curl -fLO https://github.com/Seven-Fortunas/7fchain/releases/download/$REL/SHA256SUMS
```

Downloaded with Safari or another browser instead? macOS marks browser downloads for a security check. Move the files into this folder and clear the mark on the archive before you unpack it:

```
xattr -d com.apple.quarantine 7fchain-$REL-$PLATFORM.tar.gz
```

## Verify, unpack and install

macOS uses `shasum` where Linux uses `sha256sum`:

```
grep $PLATFORM.tar.gz SHA256SUMS | shasum -a 256 -c
```

You should see your archive's name followed by **`OK`**. Then:

```
tar xzf 7fchain-$REL-$PLATFORM.tar.gz
cd 7fchain-$REL-$PLATFORM
./setup.sh
```

## Add the programs to your PATH

`setup.sh` installs `sf-node`, `sf-wallet` and `sf-explorer` into `~/.local/bin`. The Mac's shell is zsh, so add that folder to your `PATH` once:

```
echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.zshrc
```

Then open a new Terminal window. `sf-node --version` should print `sf-node 0.2.1 (ad9a103)`.

Now carry on with [step 2 of Become a miner](become-a-miner.md#2-create-your-wallet-and-miner-identity).

## Tor on a Mac

Tor comes from [Homebrew](https://brew.sh): `brew install tor`. Its settings file is `$(brew --prefix)/etc/tor/torrc`, and `brew services restart tor` applies changes. The full steps are in [Make your node reachable over Tor](tor-for-your-node.md).

## Keep it mining

- **Stay awake:** start the node as `caffeinate -i sf-node start` so the Mac doesn't sleep while it runs. A MacBook with its lid closed sleeps anyway, unless it's on power with an external display.
- **Keep running after you close Terminal:** `brew install tmux`, then follow [Keep your node running](keep-running.md).

---

Back to [Docs](README.md) · [Troubleshooting and FAQ](troubleshooting.md)
