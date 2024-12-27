#!/bin/bash

# Record the lock start time
LOCK_START=$(date +%s)

# Launch swaylock-effects with options
swaylock 

# Wait until the lock is released
wait

# Keep checking for failed attempts
while true; do
    # Get the current time
    CURRENT_TIME=$(date +%s)

    # Calculate elapsed time
    ELAPSED=$((CURRENT_TIME - LOCK_START))

    # Display time on lock screen as custom text after failed attempts
    swaylock --text="Locked for $ELAPSED seconds" &

    sleep 1
done

