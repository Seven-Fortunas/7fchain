# Install Ubuntu on Windows (WSL) to Run a 7fchain Miner

The 7fchain miner runs on **Linux**, a free operating system [1]. If your computer runs **Windows**, you don't need a second computer — a built-in Microsoft tool called **WSL** lets you run **Ubuntu** (a popular version of Linux) inside Windows [2]. This takes about 15 minutes, mostly waiting on downloads.

**You need:** Windows 11, or Windows 10 version 2004 or newer.

## 1. Open PowerShell as Administrator

**PowerShell** is a Windows command window [3]. You need to open it in **Administrator** mode, which gives it permission to install software. Right-click the Start button and choose *Terminal (Admin)* or *Windows PowerShell (Admin)*. If you're not sure how, watch a short how-to video first — it's a one-time thing [4].

## 2. Install WSL and Ubuntu

In that PowerShell window, type the following and press Enter:

```
wsl --install
```

This installs WSL and Ubuntu together. When it asks you to **restart your computer**, do so.

## 3. Create your Ubuntu user

After the restart, Ubuntu finishes setting up and opens its own window. It asks you to choose a **username** and **password** — this is your login for Ubuntu. That password is also what you'll type for admin commands (called **`sudo`**) [5]. Write it down.

> If the Ubuntu window doesn't open on its own, click the Windows **search bar**, type **Ubuntu**, and click the Ubuntu app. That's also how you open Ubuntu any time from now on — you don't need PowerShell again.

## 4. Update Ubuntu

In the Ubuntu window, type the following and press Enter (it will ask for the password from step 3):

```
sudo apt update && sudo apt upgrade -y
```

## 5. Continue as a miner

You now have Ubuntu running inside Windows. Open it any time from the search bar (type **Ubuntu**), then follow **[Become a miner](become-a-miner.md)** from step 1 — every command there works exactly as written.

**To keep mining, leave the Ubuntu window open** — closing it can stop your miner.

---

### Optional: give Ubuntu more memory

Testnet mining runs fine on a normal PC, so most people can skip this. If you ever want to give Ubuntu more memory, create a file at `C:\Users\<your-windows-name>\.wslconfig` containing:

```
[wsl2]
memory=8GB
```

Then run `wsl --shutdown` in PowerShell and reopen Ubuntu.

### Learn more

- **[1] Linux / Ubuntu** — what it is: https://ubuntu.com/desktop/wsl
- **[2] WSL** — Microsoft's official install guide: https://learn.microsoft.com/windows/wsl/install
- **[3] PowerShell / terminal basics** — https://www.youtube.com/results?search_query=windows+powershell+for+beginners
- **[4] Run PowerShell as Administrator (video)** — https://www.youtube.com/results?search_query=run+powershell+as+administrator
- **[5] What is `sudo`?** — https://www.youtube.com/results?search_query=what+is+sudo+linux
