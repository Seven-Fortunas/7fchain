#!/usr/bin/env bash
# 7fchain testnet miner - one-shot setup.
#
# Run this once after unzipping the release bundle. It:
#   1. checks your platform (Linux x86_64/aarch64 or macOS arm64/x86_64),
#   2. installs the sf-node / sf-wallet / sf-explorer programs to ~/.local/bin,
#   3. creates your node home at ~/7fchain/testnet/l1/, and
#   4. copies the public network files (genesis + dev-fund configs) into place.
#
# Your certificate AND the chain that validates it come from the registrar when
# you buy your $0.70 testnet cert (step 3 of docs/become-a-miner.md) -not from
# this bundle -so they are not installed here; intermediate-certs/ is left empty
# for you to drop the returned chain into.
#
# After it finishes, follow docs/become-a-miner.md: create a wallet, make a
# miner request, buy your $0.70 testnet certificate, and start the node.
#
# Safe to re-run: existing files are never overwritten.
#
# Expected bundle layout (this script sits at the top of the unzipped bundle):
#   ./setup.sh
#   ./bin/{sf-node,sf-wallet,sf-explorer}      (or the binaries next to setup.sh)
#   ./testnet-assets/genesis-configs/*.json
#   ./testnet-assets/devfund-configs/*.json

set -euo pipefail

BUNDLE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
HOME_DIR="$HOME/7fchain/testnet/l1"
BIN_DIR="$HOME/.local/bin"

info() { printf '  %s\n' "$1"; }
warn() { printf '  !  %s\n' "$1" >&2; }
err()  { printf '  x  %s\n' "$1" >&2; }
step() { printf '\n=== %s ===\n' "$1"; }

# Locate the binaries: prefer ./bin/, fall back to next to this script.
BIN_SRC="$BUNDLE_DIR/bin"
[ -f "$BIN_SRC/sf-node" ] || BIN_SRC="$BUNDLE_DIR"

ASSETS="$BUNDLE_DIR/testnet-assets"

# -------------------- preflight --------------------
step "0. Preflight"
OS="$(uname -s)"
ARCH="$(uname -m)"
case "$OS" in
  Linux|Darwin) ;;
  *)
    err "unsupported OS: $OS"
    err "On Windows, install Ubuntu via WSL first (see docs/become-a-miner.md)."
    exit 1
    ;;
esac
if [ ! -f "$BIN_SRC/sf-node" ] || [ ! -f "$BIN_SRC/sf-wallet" ]; then
  err "binaries not found (looked in $BUNDLE_DIR/bin and $BUNDLE_DIR) - bundle looks incomplete."
  exit 1
fi
if [ ! -d "$ASSETS" ]; then
  err "testnet-assets/ not found next to setup.sh - bundle looks incomplete."
  exit 1
fi
info "$OS $ARCH - binaries and testnet-assets present."

# -------------------- directories --------------------
step "1. Create node home: $HOME_DIR"
mkdir -p "$HOME_DIR/genesis-configs" "$HOME_DIR/devfund-configs" "$HOME_DIR/intermediate-certs" "$BIN_DIR"
info "created genesis-configs/, devfund-configs/, intermediate-certs/"
# (sf-wallet csr creates miner-0/, csr-out/, airgap-out/ itself.)

# -------------------- binaries --------------------
step "2. Install programs to $BIN_DIR"
for b in sf-node sf-wallet sf-explorer; do
  if [ -f "$BIN_SRC/$b" ]; then
    cp "$BIN_SRC/$b" "$BIN_DIR/$b"; chmod +x "$BIN_DIR/$b"; info "installed $b"
  else
    warn "$b not in bundle -skipping"
  fi
done
if ! printf '%s' ":$PATH:" | grep -q ":$BIN_DIR:"; then
  # macOS defaults to zsh; Linux to bash
  SHELL_RC="$HOME/.bashrc"
  [ "$OS" = "Darwin" ] && SHELL_RC="$HOME/.zshrc"
  if ! grep -qsE 'PATH=.*\.local/bin' "$SHELL_RC" 2>/dev/null; then
    printf '\n# Added by 7fchain setup.sh\nexport PATH="$HOME/.local/bin:$PATH"\n' >> "$SHELL_RC"
    info "added $BIN_DIR to PATH in $SHELL_RC"
  fi
  warn "$BIN_DIR is not on PATH in this shell yet - open a new terminal, or run:"
  warn "  export PATH=\"$BIN_DIR:\$PATH\""
else
  info "$BIN_DIR already on PATH"
fi

# -------------------- network files --------------------
step "3. Copy public network files"
shopt -s nullglob
copy_into() { # <src-glob-dir> <dest-dir> <label>
  for f in "$1"/*.json; do
    dest="$2/$(basename "$f")"
    if [ -f "$dest" ]; then info "skip (exists): $3/$(basename "$f")"
    else cp "$f" "$dest"; info "installed $3/$(basename "$f")"; fi
  done
}
copy_into "$ASSETS/genesis-configs" "$HOME_DIR/genesis-configs" "genesis-configs"
copy_into "$ASSETS/devfund-configs" "$HOME_DIR/devfund-configs" "devfund-configs"
info "intermediate-certs/ left empty -your registrar returns the chain with your certificate"
shopt -u nullglob

# -------------------- done --------------------
step "Done"
cat <<EOF

  Your node home is ready at:
    $HOME_DIR

  Next, follow docs/become-a-miner.md:
    1. sf-wallet init        -create your wallet (save the recovery phrase)
    2. sf-wallet csr         -make your miner request
    3. buy your \$0.70 testnet certificate, drop the returned cert into place
    4. sf-node init && sf-node start

  If "command not found", open a new terminal (or run the PATH line above).
EOF
