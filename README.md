# Kaveh-WebDiff-Monitor.sh

Kaveh WebDiff Monitor

A lightweight **HTTP change and status monitor** for tracking availability, response codes, and content changes across multiple hosts.  
Designed for both **system administrators** and **penetration testers**.

Features
-  **Scheduled Monitoring** – Runs at defined intervals to track target availability.
-  **HTTP & HTTPS Support** – Works with both protocols and ignores invalid SSL certificates if needed.
- **Virtual Host Routing** – Connect directly to an IP while sending a custom `Host` header.
-  **Content Change Detection** – Compares content size (word count) and HTTP status code.
-  **State Persistence** – Saves the last known state in `/tmp/http_mon.log` for comparison.
-  **Penetration Testing Friendly** – Detects service changes, outages, and unexpected content modifications.

Installation & Usage

1. Clone the repository
bash
git clone https://github.com/<username>/Kaveh-webdiff-monitor.git
cd Kaveh-webdiff-monitor
chmod +x Kaveh-webdiff-monitor.sh
2. Prepare a targets file

Each line should contain:
IP PORT SCHEMA VHOST

**Example:**
text
192.168.1.10 443 https example.com
10.0.0.5 80 http test.local

### 3. Run the monitor
bash
./Kaveh-webdiff-monitor.sh targets.txt

### 4. Example output
Fri Aug 15 23:45:05 UTC 2025
[*] 192.168.1.10 443 example.com: 200 157
[*] 10.0.0.5 80 test.local: 404 12
[!] Status change detected for example.com

Use Cases in Penetration Testing

**Detect content changes** during exploitation (e.g., error message differences after injection).
**Monitor virtual hosts** for newly activated services or hidden domains.
**Track server responses after stress testing** (DoS, fuzzing, or brute force).
**Identify service downtime or config changes** during MITM or WAF bypass attempts.
**Post-exploitation monitoring** to confirm changes introduced by Red Team operations.

 Notes

* `/tmp/http_mon.log` resets on system reboot — change this path if you need persistence.
* For large-scale monitoring, increase `INTERVAL` to reduce load on targets.
* Requires **Bash** and **curl**.


