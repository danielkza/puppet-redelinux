#!/bin/bash

set -ex

base_dir=$(readlink -f $(dirname "$0"))
cd "$base_dir"

puppet_dir=$(readlink -f "$base_dir/../../")
module_dir="$puppet_dir/modules" 
if ! [ -d "$module_dir" ]; then
	echo "Erro: diretório modules não encontrado em '$puppet_dir'"
	exit 1
fi

./bootstrap.sh
puppet apply --noop --modulepath="$module_dir" master.pp