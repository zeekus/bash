#!/bin/bash
#description: get a list of the pip packages that are outdated and update them
#filename: update_pip_packages.sh

# Generate a list of outdated packages
outdated_packages=$(pip list --outdated --format=freeze | cut -d'=' -f1)

# Check if there are any outdated packages
if [[ -z $outdated_packages ]]; then
  echo "No outdated packages found."
  exit 0
fi

# Loop through the outdated packages and attempt to update them
for package in $outdated_packages; do
  echo "Updating $package..."
  pip install --upgrade $package
done

echo "All packages updated successfully."