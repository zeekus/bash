#!/bin/bash
#filename: local_f95_f77_link_creater.bash
#Description: This sets up local symlinks for f95 and f77. 
#Author: Theodore Knab 

# Instructions for Users:
# ------------------------
# 1. Load the desired compiler using Spack, e.g., `spack load gcc@5.3.0` or `spack env active openmpi4` 
# 2. Run this script to update the symlinks: `./update_fortran_links.sh`.
# 3. Verify that the symlinks are pointing to the correct compiler by running:
#    `$HOME/.local/bin/f95 --version`.

# Define a directory where we will store local symlinks for compilers.
# This directory is a common place for user-specific executables.
LOCAL_LINK_DIR="$HOME/.local/bin"

# Create the directory if it doesn't already exist.
# This ensures we have a place to store our symlinks.
mkdir -p "$LOCAL_LINK_DIR"

# Function to update symlinks based on the current compiler.
# This function is called at the end of the script.
update_links() {
    # Find the path of the currently loaded gfortran compiler.
    # 'which gfortran' returns the path of the gfortran executable.
    local compiler_path=$(which gfortran)

    # Check if the compiler path was found successfully.
    if [ -n "$compiler_path" ]; then
        # Remove any existing symlinks for f95 and f77.
        # This ensures we don't have stale links pointing to old compilers.
        rm -f "$LOCAL_LINK_DIR/f95" "$LOCAL_LINK_DIR/f77"

        # Create new symlinks for f95 and f77 pointing to the current gfortran.
        # This allows users to use 'f95' and 'f77' instead of the full path to gfortran.
        ln -s "$compiler_path" "$LOCAL_LINK_DIR/f95"
        ln -s "$compiler_path" "$LOCAL_LINK_DIR/f77"

        # Update the PATH environment variable to include our local symlinks directory.
        # This ensures that when users type 'f95' or 'f77', they use the correct compiler.
        export PATH="$LOCAL_LINK_DIR:$PATH"

        # Print a success message to let the user know the symlinks were updated.
        echo "Symlinks updated successfully."

        # Print a reminder to verify the symlinks.
        echo "Please verify that the symlinks are correct by running:"
        echo "  $HOME/.local/bin/f95 --version"
    else
        # If the compiler path wasn't found, print an error message.
        echo "Error: gfortran not found. Please load a compiler using Spack."
    fi
}

# Call the function to update the symlinks.
update_links

# Print a reminder to make the PATH update persistent.
echo "To make the PATH update persistent, add the following line to your .bashrc or .bash_profile:"
echo "  export PATH=\"$HOME/.local/bin:\$PATH\""
echo "Then, reload your shell configuration with 'source ~/.bashrc'."
