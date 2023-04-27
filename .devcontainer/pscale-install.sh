#!/bin/bash

#******************************************************************************************
# pscale.sh
#
# Script to install planetscale cli and dependencies for debian based linux distros
#******************************************************************************************

# Install dependencies
sudo apt-get install default-mysql-client
# Install planetscale cli
wget https://github.com/planetscale/cli/releases/download/v0.138.0/pscale_0.138.0_linux_amd64.deb -o /tmp/pscale_0.138.0_linux_amd64.deb
sudo dpkg -i /tmp/pscale_0.138.0_linux_amd64.deb
# Create planetscale config directory
mkdir ~/.config/planetscale 