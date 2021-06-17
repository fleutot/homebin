#!/bin/bash
# Testing to only apply the layout to Kinesis keyboard.
# Get Device ID with: `xinput -list | grep -i key
kinesis_device_id=$(xinput --list | grep "05f3:0007[[:blank:]]*id=" | sed -n "s/^.*id=\(\S*\).*/\1/p")
if [ ! -z "$kinesis_device_id" ] ; then
    xkbcomp -i $kinesis_device_id $HOME/kinesis/kinesis_swe_us.conf $DISPLAY
fi

