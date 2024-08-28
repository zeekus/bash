#!/bin/bash
#filename: rebuild_spack_modules.sh
#description: checked with spack slack community on 8/28/24

environments=$(spack env list)

for env in "${environments[@]}"
do
    echo "Refreshing modules for $env"
    spack -e $env module tcl refresh --delete-tree -y
    spack -e $env module lmod refresh --delete-tree -y
done

echo "rebuilding core module area"
spack module tcl refresh --delete-tree -y
spack module lmod refresh --delete-tree -y