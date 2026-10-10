# Verify Your Download

Always verify a binary before you run it. Every 7fchain release ships a `SHA256SUMS` file listing the exact SHA-256 fingerprint of each archive. Verifying confirms your download is the genuine, unmodified file — not something corrupted in transit or swapped by an attacker.

**Only ever download from the official Releases page:**
https://github.com/Seven-Fortunas/7fchain/releases/latest

## Verify on Linux (Ubuntu / WSL)

1. Put the downloaded archive (e.g. `7fchain-testnet-2026-06-08-x86_64-linux.tar.gz`) and `SHA256SUMS` in the same folder.
2. In that folder, run:

   ```
   sha256sum -c SHA256SUMS
   ```

3. You should see your archive's name followed by **`OK`**:

   ```
   7fchain-testnet-2026-06-08-x86_64-linux.tar.gz: OK
   ```

   (Lines for other platforms' archives may say `FAILED open or read` simply because you didn't download those files — that's fine. The line for *your* archive must say `OK`.)

**If your archive's line says `FAILED` (not "FAILED open or read"), do not run the binary.** The file is corrupted or tampered with — delete it and download again from the official Releases page.

## Then continue

Unzip the verified archive and run `./setup.sh`, then return to [Become a miner](become-a-miner.md).
