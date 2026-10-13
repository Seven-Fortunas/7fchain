# Verify Your Download

Always verify a binary before you run it. Every 7fchain release ships a `SHA256SUMS` file listing the exact SHA-256 fingerprint of each archive. Verifying confirms your download is the genuine, unmodified file — not something corrupted in transit or swapped by an attacker.

**Only ever download from the official Releases page:**
https://github.com/Seven-Fortunas/7fchain/releases/latest

## Verify on Linux (Ubuntu / WSL)

1. Put the downloaded archive (e.g. `7fchain-testnet-2026-10-11-x86_64-linux.tar.gz`) and `SHA256SUMS` in the same folder.
2. In that folder, check your archive against its line in `SHA256SUMS` (use your platform — `x86_64-linux` or `aarch64-linux`):

   ```
   grep x86_64-linux.tar.gz SHA256SUMS | sha256sum -c
   ```

   `SHA256SUMS` lists the archives for every platform; `grep` picks out the line for yours, and `sha256sum -c` checks your file against it.

3. You should see your archive's name followed by **`OK`**:

   ```
   7fchain-testnet-2026-10-11-x86_64-linux.tar.gz: OK
   ```

**If it says just `FAILED`, do not run the binary.** The file is corrupted or tampered with — delete it and download again from the official Releases page.

If it says `FAILED open or read` or `no properly formatted checksum lines found`, nothing was checked yet: the archive isn't in this folder, the platform name doesn't match, or your browser renamed the file (for example with a ` (1)` added). Fix that and run the check again.

### Optional: see the comparison yourself

To see exactly what is being compared, print the fingerprint `SHA256SUMS` expects and the fingerprint of your file, one under the other:

```
echo "expected: $(grep x86_64-linux.tar.gz SHA256SUMS)"
echo "actual:   $(sha256sum 7fchain-testnet-2026-10-11-x86_64-linux.tar.gz)"
```

The two long codes must be identical, character for character:

```
expected: 03ccf5885b5db6d1668eb9e128f924b5238178a0d0214900634779b84f0f42b7  7fchain-testnet-2026-10-11-x86_64-linux.tar.gz
actual:   03ccf5885b5db6d1668eb9e128f924b5238178a0d0214900634779b84f0f42b7  7fchain-testnet-2026-10-11-x86_64-linux.tar.gz
```

(Your codes will differ from these for other platforms and later releases.)

## Then continue

Unpack the verified archive and run its setup script (use your archive's name):

```
tar xzf 7fchain-testnet-2026-10-11-x86_64-linux.tar.gz
cd 7fchain-testnet-2026-10-11-x86_64-linux
./setup.sh
```

Then return to [Become a miner](become-a-miner.md).

## Installing over an existing installation

If you already have 7fchain installed, you don't need to remove anything first — `setup.sh` upgrades in place.

1. **Stop your node** if it's running: `sf-node stop ~/7fchain/testnet/l1/node-config.json`
2. **Unpack the new release and run its setup script**, as above:
   - `./setup.sh` — replaces the programs and refreshes the network's certificates. Everything else in `~/7fchain/testnet/l1/` stays as it is: wallet, keys, miner certificate, configs and chain data.
   - `./setup.sh --clean` — use this when the release notes say the testnet was **relaunched**, or if your install dates from before the 9 October 2026 relaunch. It also clears the chain data and peer list (your node downloads them again) and replaces the network files and leftovers from older releases. Your **wallet, keys and certificates are kept**.
3. **Check the new version** — for `testnet-2026-10-11` it prints the line below:

   ```
   sf-node --version
   ```

   ```
   sf-node 0.2.1 (beab450)
   ```

4. **Start your node again** ([Run your node](run-your-node.md)).

Never delete `~/7fchain` yourself to "start fresh": it holds your wallet and keys.

