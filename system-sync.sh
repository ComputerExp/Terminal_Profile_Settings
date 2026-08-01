#!/bin/bash

# Exit immediately if apt-fast fails early
set -e

echo "=== Starting System Update Sync ==="

# 1. Run APT Updates via apt-fast
echo "--> Updating APT package lists..."
sudo /usr/bin/apt-fast update

echo "--> Upgrading system packages..."
sudo /usr/bin/nice -n -10 /usr/bin/ionice -c2 -n0 /usr/bin/apt-fast dist-upgrade -y

# 2. Prepare and Run Snap Updates (Allow errors here)
set +e
echo "--> Closing Snap Store to prevent locks..."
sudo /usr/bin/killall snap-store 2>/dev/null

echo "--> Refreshing Snaps (10-minute timeout)..."
timeout 10m sudo /usr/bin/nice -n -10 /usr/bin/ionice -c2 -n0 /usr/bin/snap refresh
SNAP_STATUS=$?

# If Snap timed out (Exit Code 124), clean up the backend database locks
if [ $SNAP_STATUS -eq 124 ]; then
    echo "Warning: Snap refresh timed out! Safely clearing locks..."
    STUCK_ID=$(snap changes | grep -E "Doing|Undoing" | awk '{print $1}' | head -n 1)
    if [ ! -z "$STUCK_ID" ]; then
        sudo /usr/bin/snap abort "$STUCK_ID"
    fi
    sudo /usr/bin/systemctl restart snapd
elif [ $SNAP_STATUS -ne 0 ]; then
    echo "Warning: Snap refresh encountered a non-timeout error (Code: $SNAP_STATUS)."
fi
set -e

# 3. System Cleanup Tasks
echo "--> Cleaning up unused packages..."
sudo /usr/bin/nice -n -5 /usr/bin/ionice -c2 -n0 /usr/bin/apt autoremove -y
sudo /usr/bin/nice -n -5 /usr/bin/ionice -c2 -n0 /usr/bin/apt clean

echo "=== All Tasks Finished! ==="

# 4. Trigger Audio/Visual Notifications
notify-send "System Sync" "All updates completed successfully!" -i software-update-available
paplay /usr/share/sounds/freedesktop/stereo/service-login.oga 2>/dev/null || true

