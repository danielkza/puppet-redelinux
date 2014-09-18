#!/bin/bash

set -e

base_dir=$(readlink -f "$(dirname "${BASH_SOURCE[0]}")")
"${base_dir}/bootstrap.sh"

puppet module install theforeman-puppet
puppet apply --noop master.pp
