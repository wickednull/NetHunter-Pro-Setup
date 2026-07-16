📱 NetHunter Pro Setup

<div align="center">

Ultimate setup & optimization script for Kali NetHunter Pro on the PinePhone

<a href="https://github.com/wickednull/NetHunter-Pro-Setup">
  <img src="https://img.shields.io/github/stars/wickednull/NetHunter-Pro-Setup?style=for-the-badge&logo=github" />
</a>
<a href="https://github.com/wickednull/NetHunter-Pro-Setup/network/members">
  <img src="https://img.shields.io/github/forks/wickednull/NetHunter-Pro-Setup?style=for-the-badge&logo=github" />
</a>
<a href="https://github.com/wickednull/NetHunter-Pro-Setup/issues">
  <img src="https://img.shields.io/github/issues/wickednull/NetHunter-Pro-Setup?style=for-the-badge" />
</a>
<a href="https://github.com/wickednull/NetHunter-Pro-Setup/blob/main/LICENSE">
  <img src="https://img.shields.io/github/license/wickednull/NetHunter-Pro-Setup?style=for-the-badge" />
</a>
<img src="https://img.shields.io/github/last-commit/wickednull/NetHunter-Pro-Setup?style=flat-square">
<img src="https://img.shields.io/github/repo-size/wickednull/NetHunter-Pro-Setup?style=flat-square">
<img src="https://img.shields.io/github/commit-activity/m/wickednull/NetHunter-Pro-Setup?style=flat-square">
<img src="https://img.shields.io/github/languages/top/wickednull/NetHunter-Pro-Setup?style=flat-square">
<br>
<img src="https://img.shields.io/badge/Kali-NetHunter%20Pro-557C94?style=flat-square&logo=kalilinux&logoColor=white">
<img src="https://img.shields.io/badge/PINE64-PinePhone-90C53F?style=flat-square">
<img src="https://img.shields.io/badge/Architecture-ARM64-0091BD?style=flat-square&logo=arm&logoColor=white">
<img src="https://img.shields.io/badge/Linux-Systemd-FCC624?style=flat-square&logo=linux&logoColor=black">
<img src="https://img.shields.io/badge/Bash-Automation-4EAA25?style=flat-square&logo=gnubash&logoColor=white">
<img src="https://img.shields.io/badge/Platform-Mobile%20Linux-success?style=flat-square">
<img src="https://img.shields.io/badge/Maintained-Yes-blue?style=flat-square">
┌──────────────────────────────────────────────────────────────┐
│                    NETHUNTER PRO SETUP                       │
│                                                              │
│   PERFORMANCE • BATTERY • SECURITY • AUTOMATION • MOBILE     │
└──────────────────────────────────────────────────────────────┘

⚡ One script. A fully configured PinePhone.

Stop wasting time manually updating packages, configuring services, tuning battery life, enabling compressed memory, hardening SSH, and setting up your workspace every time you flash NetHunter.

NetHunter Pro Setup automates the entire process, transforming a fresh Kali NetHunter Pro installation into a polished mobile Linux workstation ready for development, research, and authorized security testing.

Created by wickednull

</div>

⸻

✨ Features

🚀 System Preparation

* 📦 Fully updates Kali NetHunter Pro
* 🔄 Performs complete system upgrades
* 🧹 Removes obsolete packages
* 🗂 Cleans package cache
* 📜 Generates installation logs
* 📁 Creates an organized workspace

⸻

⚡ Performance

* 🧠 Enables ZRAM compressed swap
* 💾 Enables scheduled fstrim for eMMC longevity
* 📊 Installs btop system monitor
* 📈 Adds custom nh-status system diagnostics
* ⚙️ Configures useful shell aliases
* 🐍 Creates an isolated Python virtual environment

⸻

🔋 Battery Optimization

* 🔋 Installs and configures TLP
* 📡 Wi-Fi power saving
* 🔌 Runtime device power management
* 🎧 Audio power optimization
* 🔄 Automatic battery profile loading

⸻

🔐 Security

* 🛡 Hardened OpenSSH configuration
* 🚫 Fail2ban brute-force protection
* 🔑 Safer SSH defaults
* 📝 Comprehensive logging
* 📡 Secure remote administration

⸻

🧰 Development Environment

Automatically installs common Linux development tools:

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

Includes many commonly used tools for Linux administration and authorized security testing:

* Nmap
* Aircrack-ng
* Bettercap
* Hashcat
* John the Ripper
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

The script automatically creates:

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

Reboot after installation:

sudo reboot

⸻

📊 Included Commands

Command	Description
nh-status	Complete system information
btop	Resource monitor
update	Update and upgrade the system
cleanup	Remove unused packages
trim	Run eMMC TRIM
zram-status	Display ZRAM information
ssh-bans	View Fail2ban status
python-nh	Activate the Python environment

⸻

🖥 Screenshot

Add screenshots of your PinePhone once the project is complete.

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
