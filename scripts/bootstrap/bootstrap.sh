#!/bin/bash

set -e

codename=$(lsb_release -c -s)
package="puppetlabs-release-$codename.deb"

wget "http://apt.puppetlabs.com/$package" -O "/tmp/$package"
dpkg -i "/tmp/$package"
apt-get update
apt-get install -y puppet libaugeas-ruby 
