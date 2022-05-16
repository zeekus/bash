#!/bin/bash
#author: Theodore Knab
#date: 5/15/2022
#filename: install_nagios_from_source.sh
#description: installs nagios plugins from source

plugin="nagios-plugins-2.3.3"
plugin_file="$plugin.tar.gz"
url="https://nagios-plugins.org/download/$plugin_file"

cd /opt

if [[ -f $plugin_file ]]; then
  echo "file found skipping"
else
  echo "get compilers and other stuff"
  yum install -y gcc make vim tar wget

  echo "downloading $plugin"
  wget $url

  tar -xzvf $plugin_file
  cd $plugin

  bash ./configure
  make
  make install

  mkdir -p /usr/lib64/nagios/plugins
  cp /opt/$plugin/plugins/check* /usr/lib64/nagios/plugins/.

fi
