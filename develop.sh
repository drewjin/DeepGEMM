#!/usr/bin/zsh

# Default: do not generate compilation database
GENERATE_DB=false

# Parse arguments
while [[ "$#" -gt 0 ]]; do
    case $1 in
        -c|--compile-db) GENERATE_DB=true ;;
        -h|--help) 
            echo "Usage: $0 [-c|--compile-db]"
            echo "Options:"
            echo "  -c, --compile-db    Use 'bear' to generate compile_commands.json"
            exit 0 
            ;;
        *) echo "Unknown parameter: $1"; exit 1 ;;
    esac
    shift
done

# Change current directory into project root
original_dir=$(pwd)
script_dir=$(realpath "$(dirname "$0")")
cd "$script_dir"

# Link CUTLASS includes
# Ensure the target directory exists
mkdir -p deep_gemm/include
ln -sf $script_dir/third-party/cutlass/include/cutlass deep_gemm/include/
ln -sf $script_dir/third-party/cutlass/include/cute deep_gemm/include/

# Remove old dist file, build files, and build
rm -rf build dist
rm -rf *.egg-info

# Define the base build command
BASE_BUILD_CMD="python setup.py build"

# Wrap with bear if the flag is set
if [ "$GENERATE_DB" = true ]; then
    if command -v bear >/dev/null 2>&1; then
        echo "Building with bear enabled (generating compile_commands.json)..."
        # Bear v3.x syntax: bear -- <command>
        BUILD_CMD="bear -- $BASE_BUILD_CMD"
        CPP_DB=compile_commands.json
    else
        echo "Error: 'bear' not found. Please install it (e.g., 'sudo apt install bear')."
        exit 1
    fi
else
    BUILD_CMD="$BASE_BUILD_CMD"
fi

# Execute the build
eval $BUILD_CMD

# Handle the Compile Database
if [ "$GENERATE_DB" = true ]; then
    if [ -f "$CPP_DB" ]; then
        echo "Moving compilation database ($CPP_DB) into build directory."
        mkdir -p build
        # Remove old one if it exists in build
        rm -f build/$CPP_DB
        mv $CPP_DB build/$CPP_DB
    else
        echo "Warning: bear was executed but $CPP_DB was not generated."
    fi
fi

# Find the .so file in build directory and create symlink in current directory
so_file=$(find build -name "*.so" -type f | head -n 1)
if [ -n "$so_file" ]; then
    ln -sf "../$so_file" deep_gemm/
    echo "Success: Created symlink for $so_file in deep_gemm/"
else
    echo "Error: No SO file found in build directory" >&2
    exit 1
fi

# Return to original directory
cd "$original_dir"