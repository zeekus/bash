#!/bin/bash
#filename: loop_out_paths_for_r.sh
#description: Generates the path information in R. 
#             This is needed to install terrra and some other packages.


source /modeling/spack/share/spack/setup-env.sh

mypackages='sqlite proj gdal geos'

echo "# Setup Environment values in R from Spack values"
echo ""

for package in $mypackages; do
    location=$(spack location -i $package 2>/dev/null)
    if [ -n "$location" ]; then
        echo "# Package $package found at: $location"

        # Find lib or lib64 directory
        libdir=$(find "$location" -type d -name 'lib64' 2>/dev/null)
        if [ -z "$libdir" ]; then
            libdir=$(find "$location" -type d -name 'lib' 2>/dev/null)
        fi
        
        # Find bin directory
        bindir=$(find "$location" -type d -name 'bin' 2>/dev/null)
        
        # Find include directory
        includedir=$(find "$location" -type d -name 'include' 2>/dev/null)
        
        case $package in
            gdal)
                echo "Sys.setenv(GDAL_CONFIG=\"$bindir/gdal-config\")"
                echo "Sys.setenv(GDAL_LIB=\"$libdir\")"
                echo "Sys.setenv(GDAL_BIN=\"$bindir\")"
		echo "Sys.setenv(GDAL_ROOT=\"$location\")"
                ;;
            proj)
		echo "Sys.setenv(PROJ_ROOT=\"$location\")"
                echo "Sys.setenv(PROJ_BIN=\"$bindir\")"
                echo "Sys.setenv(PROJ_INCLUDE=\"$includedir\")"
		echo "Sys.setenv(CFLAGS = paste0(\"-I${includedir}\", Sys.getenv(\"CFLAGS\")))"
		echo "Sys.setenv(LDFLAGS = paste0(\"-L${location}/lib64\", Sys.getenv(\"LDFLAGS\")))"
                ;;
            sqlite)
                sqlite3_lib=$(find "$libdir" -name "libsqlite3.so*" | head -n 1)
                sqlite3_pkgconfig=$(find "$libdir" -name "sqlite3.pc" | head -n 1)
                if [ -n "$sqlite3_lib" ] && [ -n "$sqlite3_pkgconfig" ]; then
		    echo "Sys.setenv(SQLITE_ROOT=\"$location\")"
                    echo "sqlite3_lib=\"$sqlite3_lib\""
                    echo "sqlite3_pkgconfig=\"$sqlite3_pkgconfig\""
                    echo "Sys.setenv(PKG_CONFIG_PATH = paste0(dirname(sqlite3_pkgconfig), \":\", Sys.getenv(\"PKG_CONFIG_PATH\")))"
                    echo "Sys.setenv(LIBS = paste0(\"-L\", dirname(sqlite3_lib), \" -lsqlite3\"))"
                fi
                ;;
        esac
        echo ""
    else
        echo "# Package $package not found"
        echo ""
    fi
done

# Add LD_LIBRARY_PATH setting
echo "Sys.setenv(LD_LIBRARY_PATH = paste("
for package in gdal proj; do
    location=$(spack location -i $package 2>/dev/null)
    if [ -n "$location" ]; then
        libdir=$(find "$location" -type d -name 'lib64' 2>/dev/null)
        if [ -z "$libdir" ]; then
            libdir=$(find "$location" -type d -name 'lib' 2>/dev/null)
        fi
        if [ -n "$libdir" ]; then
            echo "  \"$libdir\","
        fi
    fi
done
echo "  Sys.getenv(\"LD_LIBRARY_PATH\"),"
echo "  sep = \":\""
echo "))"

