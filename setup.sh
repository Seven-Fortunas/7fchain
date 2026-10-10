#!/usr/bin/env bash
# 7fchain testnet miner — one-shot setup.
#
# Run this once after unzipping the release bundle. It:
#   1. checks your platform is one this release was built for,
#   2. installs the sf-node / sf-wallet / sf-explorer programs to ~/.local/bin,
#   3. creates your node home at ~/7fchain/testnet/l1/,
#   4. installs the public network files (genesis + dev-fund definitions), and
#   5. installs the public part of the certificate spine into certs/.
#
# What this bundle does NOT contain: your miner certificate, the CentCom
# certificate, and the registrar's own certificate. Those come back from the
# registrar when you buy your $0.70 testnet cert (step 3 of
# docs/become-a-miner.md). You COPY the returned certificates into certs/ —
# see the instructions this script prints when it finishes.
#
# After it finishes, follow docs/become-a-miner.md: create a wallet, make a
# miner request, buy your $0.70 testnet certificate, and start the node.
#
# Re-running:
#   ./setup.sh           Upgrade in place — replaces the programs, leaves your
#                        node home (chain data, wallet, configs) untouched.
#   ./setup.sh --clean   Clean prior install — also removes the REGENERABLE node
#                        state (chain DB blocks.redb, peer book peers.json, pid)
#                        and refreshes the network files (genesis, dev-fund and
#                        the Root/Deputy certificates) from this bundle, so a
#                        fresh start or a testnet relaunch begins clean. Your
#                        wallet, keys, miner certificate AND the certificates
#                        your registrar gave you are PRESERVED: --clean replaces
#                        only the root-*.pem and deputy-*.pem this bundle ships
#                        and leaves everything else in certs/ alone.
#
# Expected bundle layout (this script sits at the top of the unzipped bundle):
#   ./setup.sh
#   ./bin/{sf-node,sf-wallet,sf-explorer}      (or the binaries next to setup.sh)
#   ./testnet-assets/genesis-config.json
#   ./testnet-assets/devfund-config.json
#   ./testnet-assets/root-<subject key id>.pem      (the network's Root CAs)
#   ./testnet-assets/deputy-<issuing root ski>.pem  (the Deputy, once per Root)
# Those land in ~/7fchain/testnet/l1/certs/ one file per certificate, which is
# the layout sf-node reads: a directory entry means every *.pem inside it.

set -euo pipefail

CLEAN=0
for arg in "$@"; do
  case "$arg" in
    --clean|--reset) CLEAN=1 ;;
    -h|--help)
      printf 'usage: ./setup.sh [--clean]\n'
      printf '  (no flag)  upgrade in place (replace programs; keep node home)\n'
      printf '  --clean    also wipe regenerable chain state + refresh network files;\n'
      printf '             wallet, keys, and certificate are preserved\n'
      exit 0 ;;
    *) printf 'unknown option: %s  (try --help)\n' "$arg" >&2; exit 1 ;;
  esac
done

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
# Four released targets: x86_64-linux, aarch64-linux, arm64-macos, x86_64-macos.
# A bundle only ever carries the binaries for its own target, so this checks the
# platform is one we build for -- not that it matches this particular archive,
# which the binaries themselves would fail to execute if it did not.
OS="$(uname -s)"
ARCH="$(uname -m)"
case "$OS/$ARCH" in
  Linux/x86_64|Linux/aarch64|Linux/arm64) : ;;
  Darwin/arm64|Darwin/x86_64)             : ;;
  *)
    err "no 7fchain release is built for $OS/$ARCH."
    err "Released targets: x86_64-linux, aarch64-linux, arm64-macos, x86_64-macos."
    err "On Windows, install Ubuntu via WSL first (see docs/install-wsl.md)."
    exit 1 ;;
esac
if [ ! -f "$BIN_SRC/sf-node" ] || [ ! -f "$BIN_SRC/sf-wallet" ]; then
  err "binaries not found (looked in $BUNDLE_DIR/bin and $BUNDLE_DIR) — bundle looks incomplete."
  exit 1
fi
if [ ! -d "$ASSETS" ]; then
  err "testnet-assets/ not found next to setup.sh — bundle looks incomplete."
  exit 1
fi
for f in genesis-config.json devfund-config.json; do
  if [ ! -f "$ASSETS/$f" ]; then
    err "testnet-assets/$f missing — bundle looks incomplete."
    exit 1
  fi
done
info "$OS/$ARCH, binaries, and testnet-assets all present."

# -------------------- clean prior install (--clean) --------------------
if [ "$CLEAN" = 1 ]; then
  step "0b. Clean prior install (--clean)"
  info "Removing regenerable state only — wallet, keys, and certificate are KEPT."
  # Chain DB + peer book + pid + mining schedule: all regenerable (re-synced /
  # re-learned on next start). Precise removals — never an rm -rf of the home.
  for f in blocks.redb peers.json sf-node.pid mining-schedule.json; do
    if [ -e "$HOME_DIR/$f" ]; then rm -rf "$HOME_DIR/$f"; info "removed $f"; fi
  done
  # Network-provided files: single files at the home root, replaced below from
  # THIS bundle. Covers a relaunch that re-founds the chain on new Roots.
  for f in genesis-config.json devfund-config.json spine-certs.pem; do
    if [ -e "$HOME_DIR/$f" ]; then rm -f "$HOME_DIR/$f"; info "cleared $f"; fi
  done
  # Only the certificates THIS bundle ships. A CentCom or registrar certificate
  # the user copied in stays: it is not ours to replace, and re-obtaining it
  # would mean buying another one. This is the reason certs/ is a directory and
  # not a concatenated file -- a refresh can be selective.
  if [ -d "$HOME_DIR/certs" ]; then
    shopt -s nullglob
    for f in "$HOME_DIR/certs"/root-*.pem "$HOME_DIR/certs"/deputy-*.pem; do rm -f "$f"; done
    shopt -u nullglob
    info "cleared the bundle's root-*.pem and deputy-*.pem from certs/"
    kept=$(ls -1 "$HOME_DIR/certs" 2>/dev/null | wc -l)
    if [ "$kept" -gt 0 ]; then info "kept $kept certificate(s) of your own in certs/"; fi
  fi
  # Retired layout: earlier bundles created these as directories. A node that
  # still has them would otherwise keep a dead 3-root genesis sitting beside the
  # real one, so clear them out entirely.
  for d in genesis-configs devfund-configs intermediate-certs; do
    if [ -d "$HOME_DIR/$d" ]; then rm -rf "$HOME_DIR/$d"; info "removed retired $d/"; fi
  done
  # Managed programs: remove so the new build fully replaces them.
  for b in sf-node sf-wallet sf-explorer; do
    if [ -e "$BIN_DIR/$b" ]; then rm -f "$BIN_DIR/$b"; info "removed old program $b"; fi
  done
  info "PRESERVED: wallet.db.enc, miner-0/, airgap-out/, csr-out/,"
  info "           miner-cert*.json, node-config.json"
fi

# -------------------- directories --------------------
step "1. Create node home: $HOME_DIR"
mkdir -p "$HOME_DIR" "$BIN_DIR"
info "node home ready (the network files live here as single files, not folders)"
# (sf-wallet csr creates miner-0/, csr-out/, airgap-out/ itself.)

# -------------------- binaries --------------------
step "2. Install programs to $BIN_DIR"
for b in sf-node sf-wallet sf-explorer; do
  if [ -f "$BIN_SRC/$b" ]; then
    cp "$BIN_SRC/$b" "$BIN_DIR/$b"; chmod +x "$BIN_DIR/$b"; info "installed $b"
  else
    warn "$b not in bundle — skipping"
  fi
done
if ! printf '%s' ":$PATH:" | grep -q ":$BIN_DIR:"; then
  if ! grep -qsE 'PATH=.*\.local/bin' "$HOME/.bashrc" 2>/dev/null; then
    printf '\n# Added by 7fchain setup.sh\nexport PATH="$HOME/.local/bin:$PATH"\n' >> "$HOME/.bashrc"
    info "added $BIN_DIR to PATH in ~/.bashrc"
  fi
  warn "$BIN_DIR is not on PATH in this shell yet — open a new terminal, or run:"
  warn "  export PATH=\"$BIN_DIR:\$PATH\""
else
  info "$BIN_DIR already on PATH"
fi

# -------------------- network files --------------------
step "3. Install the public network files"
# One genesis definition and one dev-fund definition, each carrying every Root
# signature. The node verifies both against the Root keys compiled into
# sf-node itself, so a substituted file fails rather than being trusted.
for f in genesis-config.json devfund-config.json; do
  if [ -f "$HOME_DIR/$f" ]; then
    info "skip (exists): $f   — use --clean to refresh after a relaunch"
  else
    cp "$ASSETS/$f" "$HOME_DIR/$f"; info "installed $f"
  fi
done

# -------------------- certificate spine --------------------
step "4. Install the public certificate spine into certs/"
# One certificate per file, named by subject key id, exactly as the ceremony
# produced them. sf-node reads a directory entry as every *.pem inside it, so
# adding a certificate later is a copy -- and copying the same one twice is a
# no-op instead of a duplicate.
mkdir -p "$HOME_DIR/certs"
shopt -s nullglob
SPINE_PARTS=( "$ASSETS"/root-*.pem "$ASSETS"/deputy-*.pem )
shopt -u nullglob
if [ "${#SPINE_PARTS[@]}" -eq 0 ]; then
  warn "no root-*.pem / deputy-*.pem in testnet-assets — nothing installed."
  warn "Your node will refuse to start. Report this: the bundle is incomplete."
else
  nroot=0; ndep=0
  for f in "${SPINE_PARTS[@]}"; do
    b="$(basename "$f")"
    cp -f "$f" "$HOME_DIR/certs/$b"
    case "$b" in root-*) nroot=$((nroot+1)) ;; deputy-*) ndep=$((ndep+1)) ;; esac
  done
  info "installed $nroot Root and $ndep Deputy certificate(s) into certs/"
fi
# A node upgrading from the old layout would otherwise keep a stale bundle that
# still lists retired Roots, and the node reads BOTH the file and the directory.
if [ -f "$HOME_DIR/spine-certs.pem" ]; then
  mv -f "$HOME_DIR/spine-certs.pem" "$HOME_DIR/spine-certs.pem.superseded"
  warn "moved the old spine-certs.pem aside (now certs/ holds the spine)"
fi
info "NOT included: the CentCom certificate and the registrar's own certificate."
info "Both come back with your miner certificate; copy them into certs/."

# -------------------- done --------------------
step "Done"
cat <<EOF

  Your node home is ready at:
    $HOME_DIR

  Next, follow docs/become-a-miner.md:
    1. sf-wallet init        — create your wallet (save the recovery phrase)
    2. sf-wallet csr         — make your miner request
    3. buy your \$0.70 testnet certificate. The registrar returns your miner
       certificate AND the rest of the chain. Put the miner certificate in
       miner-0/, then copy the rest of the chain into the spine directory:

         cp centcom-cert.pem registrar-cert.pem $HOME_DIR/certs/

    4. sf-node init && sf-node start

  The node checks its spine before it will admit any chain. It needs a Deputy
  certified by a quorum of Roots -- that is what the deputy-*.pem files are --
  AND a CentCom certified by that Deputy. Until the CentCom from step 3 is in
  certs/ it will refuse to start, and say so.
EOF
