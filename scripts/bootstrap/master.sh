#!/bin/bash

set -ex

base_dir=$(readlink -f $(dirname "$0"))
cd "$base_dir"

./bootstrap.sh

puppet module install theforeman-puppet
puppet apply --noop master.pp