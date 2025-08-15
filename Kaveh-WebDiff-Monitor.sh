#!/bin/bash

# Display banner when the script starts
#!/usr/bin/env bash

BOLD="\033[1m"
GREEN="\033[32m"
RESET="\033[0m"

echo -e "${BOLD}${GREEN}
╔════════════════╗
║   TryHackBox    ║ Kaveh WebDiff Monitor
╚════════════════╝
${RESET}"

sites="$1"  # File containing ip port schema vhost
[ -z "$AGENT" ] && AGENT='Mozilla/5.0'  # Default user agent
DOWNLOAD_TIME=10  # Maximum time allowed for download (seconds)
INTERVAL=5  # Time interval between checks (seconds)

shopt -s lastpipe  # Enable lastpipe for better variable handling in pipes

while sleep $INTERVAL; do
    date  # Print current date/time
    while read ip port schema vhost; do
        # Fetch page content and HTTP status code with a single curl request
        result=$(curl -s --insecure --http1.1 --max-time $DOWNLOAD_TIME -A "$AGENT" \
            -X GET --connect-to "$vhost::$ip" -H "Host: $vhost" \
            -w "HTTPSTATUS:%{http_code}" "$schema://$vhost:$port/")
        
        # Extract HTTP status code and content
        http_code=$(echo "$result" | sed -n 's/.*HTTPSTATUS:\([0-9]*\)$/\1/p')
        content=$(echo "$result" | sed 's/HTTPSTATUS:[0-9]*$//')
        words=$(echo "$content" | wc -w)  # Count words in content

        log_entry="$ip $port $vhost: $http_code $words"  # Format log entry

        if ! grep -q "$ip $port $vhost:" /tmp/http_mon.log 2> /dev/null; then
            # Initial entry for this host
            echo "[*] $log_entry"
            echo "$log_entry" >> /tmp/http_mon.log
        elif ! grep -q "$log_entry" /tmp/http_mon.log; then
            # Status change detected
            echo "[-] $(grep "$ip $port $vhost:" /tmp/http_mon.log)"  # Old status
            echo "[+] $log_entry"  # New status
            # Alert - text message
            echo "[!] Status changed for $vhost"
        fi
    done < "$sites"
done
