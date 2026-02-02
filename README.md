````md
# Echolocate

**Echolocate** is a Bash-based reconnaissance and enumeration automation script designed to streamline common penetration testing and CTF workflows. It wraps multiple tools into a single execution flow to save time during target discovery and analysis.

> ⚠️ **For educational purposes only.** Use only on systems you own or have explicit permission to test.

---

## Features

- Automated reconnaissance workflow
- Supports common pentesting tools (e.g. `nmap`, `sqlmap`, `john`, `hashcat`, etc.)
- Optional wordlist support with **custom paths**
- Single-script execution (no separated modules)
- Designed for CTFs, labs (TryHackMe, Hack The Box), and learning environments

---

## Requirements

Make sure the following tools are installed before running the script:

- `bash`
- `nmap`
- `sqlmap`
- `john`
- `hashcat`
- `curl`
- `wget`

On Debian-based systems (Kali, Ubuntu, Linux Mint):

```bash
sudo apt update
sudo apt install nmap sqlmap john hashcat curl wget -y
````

---

## Installation

Clone the repository:

```bash
git clone https://github.com/yourusername/echolocate.git
cd echolocate
```

Make the script executable:

```bash
chmod +x echolocate.sh
```

---

## Usage

Run the script:

```bash
./echolocate.sh
```

### Example (with custom wordlist path)

```bash
10.10.10.10 -w /usr/share/wordlists/rockyou.txt
```

> 📌 When using wordlists, **you can specify a custom path** instead of relying on default locations.

---

## Notes

* Run as **root** if required by certain tools (e.g. `nmap` scans):

  ```bash
  sudo ./echolocate.sh
  ```
* Make sure wordlists are uncompressed if required:

  ```bash
  gunzip /usr/share/wordlists/rockyou.txt.gz
  ```
* Output locations depend on script configuration.

---

## Disclaimer

This tool is intended **strictly for educational and authorized testing purposes**.
The author is **not responsible** for any misuse or damage caused by this script.

---

## Author

Created by **Jerryco Adriano**
Cybersecurity Enthusiast | CTF Player | Offensive Security Learner
