<div align="center">

📱 NetHunter Pro Setup

Ultimate setup & optimization script for Kali NetHunter Pro on the PinePhone

<p>
  <a href="https://github.com/wickednull/NetHunter-Pro-Setup">
    <img src="https://img.shields.io/github/stars/wickednull/NetHunter-Pro-Setup?style=for-the-badge&logo=github" />
  </a>
  <a href="https://github.com/wickednull/NetHunter-Pro-Setup/network/members">
    <img src="https://img.shields.io/github/forks/wickednull/NetHunter-Pro-Setup?style=for-the-badge&logo=github" />
  </a>
  <a href="https://github.com/wickednull/NetHunter-Pro-Setup/issues">
    <img src="https://img.shields.io/github/issues/wickednull/NetHunter-Pro-Setup?style=for-the-badge" />
  </a>
  <img src="https://img.shields.io/github/license/wickednull/NetHunter-Pro-Setup?style=for-the-badge">
</p>
<p>
<img src="https://img.shields.io/badge/Kali-NetHunter-557C94?style=flat-square&logo=kalilinux&logoColor=white">
<img src="https://img.shields.io/badge/PINE64-PinePhone-90C53F?style=flat-square">
<img src="https://img.shields.io/badge/Architecture-ARM64-0091BD?style=flat-square&logo=arm">
<img src="https://img.shields.io/badge/Linux-Systemd-FCC624?style=flat-square&logo=linux&logoColor=black">
<img src="https://img.shields.io/badge/Bash-Automation-4EAA25?style=flat-square&logo=gnubash&logoColor=white">
<img src="https://img.shields.io/badge/Status-Active-success?style=flat-square">
</p>

⸻

⚡ One script. A fully configured PinePhone.

Stop wasting time manually installing packages, configuring services, tweaking battery settings, enabling compressed memory, hardening SSH, and setting up your workspace every time you flash NetHunter.

NetHunter Pro Setup automates the entire process and transforms a fresh Kali NetHunter Pro installation into a polished mobile Linux workstation ready for development, research, and authorized security testing.

</div>

⸻

✨ Features

🚀 System Preparation

* 📦 Fully updates Kali NetHunter Pro
* 🔄 Performs full system upgrades
* 🧹 Removes obsolete packages
* 🗂 Cleans package cache
* 📜 Creates installation logs

⸻

⚡ Performance

* 🧠 Enables ZRAM compressed swap
* 💾 Enables automatic fstrim for eMMC
* 📊 Installs btop
* 📈 Creates custom system status tools
* ⚙️ Optimized shell aliases

⸻

🔋 Battery Optimization

* 🔋 Installs and configures TLP
* 📡 Wi-Fi power saving
* 🔌 Runtime power management
* 🎧 Audio power optimization
* 🔄 Automatic battery profile loading

⸻

🔐 Security

* 🛡 SSH hardening
* 🚫 Fail2ban protection
* 🔑 Safer SSH defaults
* 📝 System logging
* 📡 Secure remote administration

⸻

🧰 Development Environment

Automatically installs common Linux development tools including:

* Git
* Python
* Pip
* Virtual Environments
* Build Essentials
* CMake
* tmux
* curl
* wget
* jq
* ripgrep
* fzf
* bat

⸻

📡 Networking & Security Tools

Includes many commonly used tools found in mobile security workflows:

* Nmap
* Aircrack-ng
* Bettercap
* Hashcat
* John
* Hydra
* SQLMap
* Gobuster
* ffuf
* WhatWeb
* Nikto
* Metasploit Framework
* Responder
* tcpdump
* Wireshark CLI
* WireGuard

⸻

📁 Workspace

The script automatically creates a clean workspace.

~/Tools
~/Projects
~/Captures
~/Loot
~/Payloads
~/Reports
~/Scripts
~/Logs
~/Wordlists

⸻

⚡ Quick Install

git clone https://github.com/wickednull/NetHunter-Pro-Setup.git
cd NetHunter-Pro-Setup
chmod +x nethunter-setup.sh
sudo ./nethunter-setup.sh

Reboot afterwards:

sudo reboot

⸻

📊 Included Commands

Command	Description
nh-status	Full system information
btop	Resource monitor
update	Update the system
cleanup	Remove unused packages
trim	Run eMMC TRIM
zram-status	Display compressed swap
ssh-bans	View Fail2ban status
python-nh	Activate Python environment

⸻

🖥 Screenshot

Add screenshots of your PinePhone here once the project is complete.

┌────────────────────────────────────────────┐
│     NetHunter Pro PinePhone Ready          │
│                                            │
│ ✓ ZRAM Enabled                             │
│ ✓ TLP Running                              │
│ ✓ Fail2ban Active                          │
│ ✓ SSH Hardened                             │
│ ✓ btop Installed                           │
│ ✓ Workspace Created                        │
│ ✓ Ready for Research                       │
└────────────────────────────────────────────┘

⸻

⚠️ Disclaimer

This project is intended for education, research, system administration, bug bounty programs, and authorized security testing only. Always ensure you have permission before assessing or interacting with systems you do not own.

⸻

<div align="center">

Created by wickednull

Building better mobile Linux tools.

</div>
