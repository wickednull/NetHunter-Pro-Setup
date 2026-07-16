#!/usr/bin/env bash
#
# NetHunter Pro PinePhone Setup & Optimization
# Created by Null_Lyfe
#
# Includes:
#   - System updates
#   - Essential development and security tools
#   - ZRAM compressed swap
#   - TLP battery optimization
#   - Periodic eMMC trimming
#   - OpenSSH and Fail2ban protection
#   - btop resource monitoring
#   - Workspace directories
#   - Useful shell aliases
#

set -Eeuo pipefail

LOG_FILE="/var/log/nethunter-pro-setup.log"
REAL_USER="${SUDO_USER:-${USER:-root}}"
REAL_HOME="$(getent passwd "$REAL_USER" | cut -d: -f6)"

[[ -n "$REAL_HOME" ]] || REAL_HOME="/root"

exec > >(tee -a "$LOG_FILE") 2>&1

trap 'echo "[!] Setup stopped near line $LINENO. Review $LOG_FILE"' ERR

print_header() {
    clear
    cat <<'EOF'
============================================================
       NETHUNTER PRO PINEPHONE SETUP & OPTIMIZATION
                    Created by wickednull
============================================================
EOF
}

section() {
    echo
    echo "============================================================"
    echo "[+] $1"
    echo "============================================================"
}

command_exists() {
    command -v "$1" >/dev/null 2>&1
}

service_exists() {
    systemctl list-unit-files "$1" 2>/dev/null |
        grep -q "^${1}"
}

enable_service() {
    local service="$1"

    if service_exists "$service"; then
        systemctl enable --now "$service" || {
            echo "[!] Could not enable $service"
            return 1
        }
    else
        echo "[!] Service not found: $service"
    fi
}

install_packages() {
    local available=()
    local unavailable=()
    local package

    for package in "$@"; do
        if apt-cache show "$package" >/dev/null 2>&1; then
            available+=("$package")
        else
            unavailable+=("$package")
        fi
    done

    if (( ${#available[@]} > 0 )); then
        DEBIAN_FRONTEND=noninteractive apt-get install -y \
            --no-install-recommends "${available[@]}"
    fi

    if (( ${#unavailable[@]} > 0 )); then
        echo "[!] These packages were unavailable and were skipped:"
        printf '    - %s\n' "${unavailable[@]}"
    fi
}

append_once() {
    local text="$1"
    local file="$2"
    local marker="$3"

    touch "$file"

    if ! grep -Fq "$marker" "$file"; then
        printf '%s\n' "$text" >> "$file"
    fi
}

print_header

if [[ "${EUID}" -ne 0 ]]; then
    echo "[!] Run this script as root:"
    echo "    sudo bash $0"
    exit 1
fi

if [[ ! -f /etc/os-release ]]; then
    echo "[!] Unable to identify this Linux installation."
    exit 1
fi

source /etc/os-release

echo "[+] Distribution: ${PRETTY_NAME:-Unknown Linux}"
echo "[+] Configuring account: $REAL_USER"
echo "[+] Home directory: $REAL_HOME"
echo "[+] Log file: $LOG_FILE"

section "Checking power source"

BATTERY_CAPACITY="unknown"

for capacity_file in /sys/class/power_supply/*/capacity; do
    if [[ -r "$capacity_file" ]]; then
        BATTERY_CAPACITY="$(cat "$capacity_file")"
        break
    fi
done

if [[ "$BATTERY_CAPACITY" =~ ^[0-9]+$ ]]; then
    echo "[+] Battery capacity: ${BATTERY_CAPACITY}%"

    if (( BATTERY_CAPACITY < 30 )); then
        echo "[!] Battery is below 30%."
        echo "[!] Connect the PinePhone to a charger before continuing."
        exit 1
    fi
else
    echo "[*] Battery percentage could not be detected."
fi

section "Updating package repositories"

apt-get update

section "Upgrading installed packages"

DEBIAN_FRONTEND=noninteractive apt-get full-upgrade -y

section "Installing system essentials"

install_packages \
    ca-certificates \
    curl \
    wget \
    git \
    rsync \
    openssh-client \
    openssh-server \
    vim \
    nano \
    tmux \
    screen \
    btop \
    tree \
    jq \
    ripgrep \
    fd-find \
    fzf \
    bat \
    zip \
    unzip \
    p7zip-full \
    file \
    less \
    man-db \
    bash-completion \
    build-essential \
    cmake \
    pkg-config \
    python3 \
    python3-pip \
    python3-venv \
    python3-dev \
    pipx \
    net-tools \
    iproute2 \
    iputils-ping \
    dnsutils \
    traceroute \
    whois \
    ethtool \
    rfkill \
    usbutils \
    pciutils \
    lsof \
    strace \
    socat \
    util-linux

section "Installing security and networking tools"

install_packages \
    nmap \
    masscan \
    tcpdump \
    tshark \
    wireshark-common \
    aircrack-ng \
    hcxdumptool \
    hcxtools \
    hashcat \
    john \
    hydra \
    responder \
    sqlmap \
    gobuster \
    ffuf \
    feroxbuster \
    nikto \
    whatweb \
    exploitdb \
    metasploit-framework \
    bettercap \
    proxychains4 \
    macchanger \
    netcat-openbsd \
    wireguard-tools

section "Installing optimization and protection packages"

install_packages \
    zram-tools \
    tlp \
    fail2ban \
    smartmontools

section "Configuring ZRAM"

if dpkg-query -W -f='${Status}' zram-tools 2>/dev/null |
    grep -q "install ok installed"; then

    cat > /etc/default/zramswap <<'EOF'
# NetHunter Pro ZRAM configuration
# Use compressed RAM as high-priority swap.

ALGO=zstd
PERCENT=50
PRIORITY=100
EOF

    if service_exists "zramswap.service"; then
        systemctl enable zramswap.service
        systemctl restart zramswap.service
    else
        echo "[!] zramswap.service was not found."
    fi

    echo "[+] Current swap configuration:"
    swapon --show || true
    zramctl || true
else
    echo "[!] zram-tools was not installed; ZRAM configuration skipped."
fi

section "Configuring TLP battery management"

if dpkg-query -W -f='${Status}' tlp 2>/dev/null |
    grep -q "install ok installed"; then

    # TLP and power-profiles-daemon can compete over power settings.
    if service_exists "power-profiles-daemon.service"; then
        systemctl disable --now power-profiles-daemon.service || true
        systemctl mask power-profiles-daemon.service || true
    fi

    cat > /etc/tlp.d/99-nethunter-pinephone.conf <<'EOF'
# NetHunter Pro PinePhone battery configuration

# Restore saved radio state when TLP starts.
RESTORE_DEVICE_STATE_ON_STARTUP=1

# Wi-Fi power saving.
WIFI_PWR_ON_AC=off
WIFI_PWR_ON_BAT=on

# Runtime power management.
RUNTIME_PM_ON_AC=auto
RUNTIME_PM_ON_BAT=auto

# Avoid aggressive autosuspend of important input and communication devices.
USB_EXCLUDE_BTUSB=1
USB_EXCLUDE_PHONE=1
USB_EXCLUDE_PRINTER=1
USB_EXCLUDE_WWAN=1

# Sound-device power saving.
SOUND_POWER_SAVE_ON_AC=0
SOUND_POWER_SAVE_ON_BAT=1

# PCIe power management, where supported.
PCIE_ASPM_ON_AC=default
PCIE_ASPM_ON_BAT=powersupersave
EOF

    if service_exists "tlp.service"; then
        systemctl enable tlp.service
        systemctl restart tlp.service
    fi

    if command_exists tlp; then
        tlp start || true
        tlp-stat -s || true
    fi
else
    echo "[!] TLP was not installed; battery optimization skipped."
fi

section "Enabling periodic eMMC trimming"

if command_exists fstrim; then
    if service_exists "fstrim.timer"; then
        systemctl enable --now fstrim.timer

        echo "[+] fstrim timer status:"
        systemctl list-timers fstrim.timer --no-pager || true
    else
        echo "[!] fstrim.timer was not found."
    fi

    echo "[+] Testing whether mounted filesystems support trimming:"
    fstrim --all --verbose || {
        echo "[*] One or more filesystems did not advertise discard support."
        echo "[*] The timer remains enabled and will trim supported filesystems."
    }
else
    echo "[!] fstrim is unavailable."
fi

section "Configuring OpenSSH"

if dpkg-query -W -f='${Status}' openssh-server 2>/dev/null |
    grep -q "install ok installed"; then

    install -d -m 0755 /etc/ssh/sshd_config.d

    cat > /etc/ssh/sshd_config.d/99-nethunter-security.conf <<'EOF'
# NetHunter Pro SSH security settings

PermitRootLogin prohibit-password
MaxAuthTries 4
LoginGraceTime 30
X11Forwarding no
ClientAliveInterval 300
ClientAliveCountMax 2
EOF

    if command_exists sshd; then
        sshd -t
    fi

    enable_service "ssh.service" || true
else
    echo "[!] OpenSSH server was not installed."
fi

section "Configuring Fail2ban"

if dpkg-query -W -f='${Status}' fail2ban 2>/dev/null |
    grep -q "install ok installed"; then

    cat > /etc/fail2ban/jail.d/nethunter-ssh.conf <<'EOF'
[DEFAULT]
bantime  = 1h
findtime = 10m
maxretry = 5
backend  = systemd

[sshd]
enabled = true
port = ssh
filter = sshd
logpath = %(sshd_log)s
EOF

    if command_exists fail2ban-client; then
        fail2ban-client -t
    fi

    enable_service "fail2ban.service" || true

    sleep 2

    fail2ban-client status || true
    fail2ban-client status sshd || true
else
    echo "[!] Fail2ban was not installed."
fi

section "Configuring Python workspace"

if command_exists pipx; then
    sudo -u "$REAL_USER" env HOME="$REAL_HOME" pipx ensurepath || true
fi

python3 -m venv "$REAL_HOME/.venvs/nethunter"

"$REAL_HOME/.venvs/nethunter/bin/python" -m pip install --upgrade \
    pip \
    setuptools \
    wheel

"$REAL_HOME/.venvs/nethunter/bin/python" -m pip install \
    requests \
    rich \
    psutil \
    scapy \
    pycryptodome \
    pyserial

chown -R "$REAL_USER:$REAL_USER" "$REAL_HOME/.venvs"

section "Creating NetHunter workspace"

DIRECTORIES=(
    "$REAL_HOME/Tools"
    "$REAL_HOME/Projects"
    "$REAL_HOME/Captures"
    "$REAL_HOME/Wordlists"
    "$REAL_HOME/Loot"
    "$REAL_HOME/Scripts"
    "$REAL_HOME/Payloads"
    "$REAL_HOME/Reports"
    "$REAL_HOME/Logs"
    "$REAL_HOME/.local/bin"
)

for directory in "${DIRECTORIES[@]}"; do
    mkdir -p "$directory"
done

chown -R "$REAL_USER:$REAL_USER" \
    "$REAL_HOME/Tools" \
    "$REAL_HOME/Projects" \
    "$REAL_HOME/Captures" \
    "$REAL_HOME/Wordlists" \
    "$REAL_HOME/Loot" \
    "$REAL_HOME/Scripts" \
    "$REAL_HOME/Payloads" \
    "$REAL_HOME/Reports" \
    "$REAL_HOME/Logs" \
    "$REAL_HOME/.local"

section "Configuring Git"

sudo -u "$REAL_USER" env HOME="$REAL_HOME" \
    git config --global init.defaultBranch main

sudo -u "$REAL_USER" env HOME="$REAL_HOME" \
    git config --global pull.rebase false

sudo -u "$REAL_USER" env HOME="$REAL_HOME" \
    git config --global core.editor nano

section "Adding shell aliases"

BASHRC="$REAL_HOME/.bashrc"

touch "$BASHRC"
chown "$REAL_USER:$REAL_USER" "$BASHRC"

if ! grep -Fq "# NET HUNTER PRO ALIASES" "$BASHRC"; then
    cat >> "$BASHRC" <<'EOF'

# NET HUNTER PRO ALIASES
alias ll='ls -lah --color=auto'
alias la='ls -A --color=auto'
alias cls='clear'
alias ports='ss -tulpn'
alias ips='ip -br address'
alias routes='ip route'
alias mem='free -h'
alias disk='df -hT'
alias temps='for f in /sys/class/thermal/thermal_zone*/temp; do printf "%s: " "$f"; awk "{printf \"%.1f°C\n\", \$1/1000}" "$f"; done'
alias battery='upower -i "$(upower -e 2>/dev/null | grep BAT | head -n1)" 2>/dev/null || cat /sys/class/power_supply/*/capacity 2>/dev/null'
alias top='btop'
alias update='sudo apt update && sudo apt full-upgrade -y'
alias cleanup='sudo apt autoremove --purge -y && sudo apt clean'
alias trim='sudo fstrim --all --verbose'
alias zram-status='zramctl && swapon --show'
alias ssh-bans='sudo fail2ban-client status sshd'
alias myip='curl -4 https://ifconfig.me; echo'
alias python-nh='source ~/.venvs/nethunter/bin/activate'

export HISTCONTROL=ignoreboth:erasedups
export HISTSIZE=50000
export HISTFILESIZE=100000
export HISTTIMEFORMAT='%F %T  '
shopt -s histappend
PROMPT_COMMAND='history -a; history -n'
EOF
fi

chown "$REAL_USER:$REAL_USER" "$BASHRC"

section "Creating system-information command"

cat > /usr/local/bin/nh-status <<'EOF'
#!/usr/bin/env bash

echo "============================================================"
echo " NetHunter Pro System Status"
echo "============================================================"

echo
echo "--- SYSTEM ---"
hostnamectl 2>/dev/null || uname -a

echo
echo "--- UPTIME ---"
uptime

echo
echo "--- MEMORY ---"
free -h

echo
echo "--- ZRAM AND SWAP ---"
zramctl 2>/dev/null || true
swapon --show 2>/dev/null || true

echo
echo "--- FILESYSTEMS ---"
df -hT /

echo
echo "--- BATTERY ---"
for supply in /sys/class/power_supply/*; do
    [[ -r "$supply/type" ]] || continue

    if [[ "$(cat "$supply/type")" == "Battery" ]]; then
        echo "Device: $(basename "$supply")"
        [[ -r "$supply/capacity" ]] &&
            echo "Capacity: $(cat "$supply/capacity")%"
        [[ -r "$supply/status" ]] &&
            echo "Status: $(cat "$supply/status")"
    fi
done

echo
echo "--- TEMPERATURES ---"
for zone in /sys/class/thermal/thermal_zone*; do
    [[ -r "$zone/temp" ]] || continue

    name="$(basename "$zone")"
    type="$(cat "$zone/type" 2>/dev/null || echo unknown)"
    temp="$(cat "$zone/temp")"

    awk -v name="$name" -v type="$type" -v temp="$temp" \
        'BEGIN {printf "%s (%s): %.1f°C\n", name, type, temp / 1000}'
done

echo
echo "--- ACTIVE OPTIMIZATION SERVICES ---"
systemctl is-active zramswap.service 2>/dev/null |
    sed 's/^/ZRAM: /' || true

systemctl is-active tlp.service 2>/dev/null |
    sed 's/^/TLP: /' || true

systemctl is-active fstrim.timer 2>/dev/null |
    sed 's/^/fstrim timer: /' || true

systemctl is-active fail2ban.service 2>/dev/null |
    sed 's/^/Fail2ban: /' || true

systemctl is-active ssh.service 2>/dev/null |
    sed 's/^/SSH: /' || true

echo
echo "--- NETWORK ---"
ip -br address
EOF

chmod 0755 /usr/local/bin/nh-status

section "Cleaning package cache"

apt-get autoremove --purge -y
apt-get autoclean
apt-get clean

section "Final service checks"

SERVICES=(
    "zramswap.service"
    "tlp.service"
    "fstrim.timer"
    "ssh.service"
    "fail2ban.service"
)

for service in "${SERVICES[@]}"; do
    if service_exists "$service"; then
        printf "%-25s %s\n" \
            "$service" \
            "$(systemctl is-active "$service" 2>/dev/null || true)"
    fi
done

echo
echo "============================================================"
echo " NetHunter Pro setup completed"
echo "============================================================"
echo
echo "User:        $REAL_USER"
echo "Log:         $LOG_FILE"
echo "System info: nh-status"
echo "Monitor:     btop"
echo "ZRAM info:   zram-status"
echo "SSH bans:    ssh-bans"
echo
echo "Reboot the PinePhone to apply every optimization:"
echo
echo "    sudo reboot"
echo