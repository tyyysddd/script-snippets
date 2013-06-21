#!/bin/sh
#
# print total CPU usage of each user logged in
#

set -e

OWN=$(id -nu)

for USER in $(who | awk '{print $1}' | sort -u)
do
    # print other user's CPU usage in parallel but skip own one because
    # spawning many processes will increase our CPU usage significantly
    if [ "$USER" = "$OWN" ]; then continue; fi
    (top -b -n 1 -u "$USER" | awk -v user=$USER 'NR>7 { sum += $9; } END { print user, sum; }') &
done
wait

# print own CPU usage after all spawned processes completed
top -b -n 1 -u "$OWN" | awk -v user=$OWN 'NR>7 { sum += $9; } END { print user, sum; }'