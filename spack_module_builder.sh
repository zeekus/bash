#!/bin/bash

# Load Spack environment
source /path/to/spack/share/spack/setup-env.sh

# Define the packages you want to install
packages=(
  package1
  package2
  package3
)

# Install the packages
for package in "${packages[@]}"; do
  spack install $package
done

# Create a modulefile
modulefile_path=/path/to/modulefile
module_name=my_module

# Load the Spack environment in the modulefile
echo "#%Module" > $modulefile_path
echo "source /path/to/spack/share/spack/setup-env.sh" >> $modulefile_path

# Add the installed packages to the modulefile
for package in "${packages[@]}"; do
  echo "spack load $package" >> $modulefile_path
done

# Add the modulefile to the module search path
module use /path/to/modulefiles

# Create a symlink to the modulefile
ln -s $modulefile_path /path/to/modulefiles/$module_name
