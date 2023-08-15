#!/bin/bash

# Load Spack environment
source /path/to/spack/share/spack/setup-env.sh

# Define the packages you want to build modules for
packages=(
  package1
  package2
  package3
)

# Build modules for the packages
for package in "${packages[@]}"; do
  spack module tcl refresh -y $package
done

