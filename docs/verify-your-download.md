# Verify Your Download

Always verify a binary before you run it. Every 7fchain release ships a `SHA256SUMS` file listing the exact SHA-256 fingerprint of each archive. Verifying confirms your download is the genuine, unmodified file — not something corrupted in transit or swapped by an attacker.

**Only ever download from the official Releases page:**
https://github.com/Seven-Fortunas/7fchain/releases/latest

The examples below use release `testnet-2026-10-16.2` on `x86_64-linux`. Use your own release and platform: `x86_64-linux`, `aarch64-linux`, `arm64-macos` or `x86_64-macos` (`uname -sm` tells you which; see the table in [Update your miner](update-your-miner.md#1-download-the-new-release)).

## Check the fingerprint

1. Put the downloaded archive (e.g. `7fchain-testnet-2026-10-16.2-x86_64-linux.tar.gz`) and `SHA256SUMS` in the same folder.
2. In that folder, check your archive against its line in `SHA256SUMS`.

   On Linux (Ubuntu / WSL):

   ```
   grep x86_64-linux.tar.gz SHA256SUMS | sha256sum -c
   ```

   On macOS (this example is for Apple silicon, `arm64-macos`):

   ```
   grep arm64-macos.tar.gz SHA256SUMS | shasum -a 256 -c
   ```

   `SHA256SUMS` lists the archives for every platform; `grep` picks out the line for yours, and `sha256sum -c` (or `shasum -a 256 -c`) checks your file against it.

3. You should see your archive's name followed by **`OK`**:

   ```
   7fchain-testnet-2026-10-16.2-x86_64-linux.tar.gz: OK
   ```

**If it says just `FAILED`, do not run the binary.** The file is corrupted or tampered with — delete it and download again from the official Releases page.

If it says `FAILED open or read` or `no properly formatted checksum lines found`, nothing was checked yet: the archive isn't in this folder, the platform name doesn't match, or your browser renamed the file (for example with a ` (1)` added). Fix that and run the check again.

### Optional: see the comparison yourself

To see exactly what is being compared, print the fingerprint `SHA256SUMS` expects and the fingerprint of your file, one under the other (on macOS, use `shasum -a 256` in place of `sha256sum`):

```
echo "expected: $(grep x86_64-linux.tar.gz SHA256SUMS)"
echo "actual:   $(sha256sum 7fchain-testnet-2026-10-16.2-x86_64-linux.tar.gz)"
```

The two long codes must be identical, character for character:

```
expected: 80c4eb87fc60737c376c17c555d09c4e6c2559c7d66e15d5e889b96d6da19687  7fchain-testnet-2026-10-16.2-x86_64-linux.tar.gz
actual:   80c4eb87fc60737c376c17c555d09c4e6c2559c7d66e15d5e889b96d6da19687  7fchain-testnet-2026-10-16.2-x86_64-linux.tar.gz
```

(Your codes will differ from these for other platforms and later releases.)

## Then continue

Unpack the verified archive and run its setup script (use your archive's name):

```
tar xzf 7fchain-testnet-2026-10-16.2-x86_64-linux.tar.gz
cd 7fchain-testnet-2026-10-16.2-x86_64-linux
./setup.sh
```

Then return to [Become a miner](become-a-miner.md).

## Installing over an existing installation

Already running a node? Follow [Update your miner](update-your-miner.md): it covers stopping the node, `./setup.sh --clean` after a testnet restart, replacing your certificates and starting again.
