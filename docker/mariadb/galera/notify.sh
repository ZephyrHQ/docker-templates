#!/bin/bash
source /galera.sh
echo $* > /cache/notify
if [[ "$1 $2" = "--status Synced" ]]
then
    echo "end" > /cache/notify
fi