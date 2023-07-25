#!/bin/bash

# Check if puppet agent is running
if ps auxww | grep -i puppet | grep -i agent > /dev/null; then
    echo "Puppet agent is already running"
else
    # Start puppet agent
    echo "Starting puppet agent..."
    systemctl start puppet

    # Check if puppet agent started successfully
    if ps auxww | grep -i puppet | grep -i agent > /dev/null; then
        echo "Puppet agent started successfully"
    else
        echo "Failed to start puppet agent"
    fi
fi