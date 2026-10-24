# 7fchain on macOS

> **The current release is for Linux.** Mine on Linux, or on Windows through [WSL](install-wsl.md). The steps below apply when a release lists Mac archives (`arm64-macos`, `x86_64-macos`).

On a Mac, follow [Become a miner](become-a-miner.md) as on Linux, with these differences.

**Your platform.** In Terminal, `uname -sm` prints `Darwin arm64` for Apple silicon (`arm64-macos`) or `Darwin x86_64` for Intel (`x86_64-macos`).

**Download in Terminal**, so macOS lets the programs run (set `REL` to the current release and `PLATFORM` to yours):

```
REL=testnet-2026-10-22
PLATFORM=arm64-macos
mkdir -p ~/7fchain-releases/$REL && cd ~/7fchain-releases/$REL
curl -fLO https://github.com/Seven-Fortunas/7fchain/releases/download/$REL/7fchain-$REL-$PLATFORM.tar.gz
curl -fLO https://github.com/Seven-Fortunas/7fchain/releases/download/$REL/SHA256SUMS
```

**Verify** with `shasum` instead of `sha256sum`:

```
grep $PLATFORM.tar.gz SHA256SUMS | shasum -a 256 -c
```

If you downloaded with a browser instead, and only after the check printed `OK`, run `xattr -d com.apple.quarantine 7fchain-$REL-$PLATFORM.tar.gz` before you unpack it.

**Add the programs to your `PATH`** once, after `./setup.sh`, then open a new Terminal window:

```
echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.zshrc
```

**Keep the Mac awake** while it mines: start the node with `caffeinate -i sf-node start`. A MacBook with its lid closed still sleeps unless it's on power with an external display.

Tor and `tmux` come from [Homebrew](https://brew.sh); the [Tor guide](tor-for-your-node.md) and [Keep your node running](keep-running.md) have the Mac commands.

---

Back to [Docs](README.md) · [Troubleshooting and FAQ](troubleshooting.md)
