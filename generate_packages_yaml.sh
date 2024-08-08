#!/bin/bash
# filename: generate_packages_yaml.sh
# description: Generates a packages.yaml file for Spack with external package paths

source /modeling/spack/share/spack/setup-env.sh

mypackages='sqlite proj gdal geos'
output_file="packages.yaml"

echo "Generating $output_file..."

# Start the YAML file
cat <<EOL > $output_file
packages:
EOL

for package in $mypackages; do
    location=$(spack location -i $package 2>/dev/null)
    if [ -n "$location" ]; then
        echo "  $package:" >> $output_file
        echo "    externals:" >> $output_file
        echo "    - spec: $package@$(spack find --format {version} $package)" >> $output_file
        echo "      prefix: $location" >> $output_file
        echo "    buildable: false" >> $output_file
        echo "" >> $output_file
    else
        echo "# Package $package not found, skipping..." >&2
    fi
done

echo "Done. The $output_file file has been created."

