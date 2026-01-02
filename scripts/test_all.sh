#!/usr/bin/zsh

# 1. Change directory to the project root (where the script is located)
# This ensures the tests are run from the correct context
PROJECT_ROOT=$(pwd)

# 2. Set environment variables if needed
# For example, ensure the local deep_gemm package is used
export PYTHONPATH=$PYTHONPATH:$(pwd)

# 3. Check if pytest is installed
if ! command -v pytest &> /dev/null; then
    echo "Error: 'pytest' is not installed. Run 'pip install pytest' first."
    exit 1
fi

echo "===================================================="
echo "Running DeepGEMM Test Suite"
echo "Project Root: $PROJECT_ROOT"
echo "===================================================="

# 4. Execute pytest
# -v: Verbose output (shows names of each test)
# -s: Don't capture stdout (allows printing from kernels/tests to be visible)
# tests/: The directory containing test files
# "$@": Forwards any additional arguments passed to this script to pytest
pytest tests/ -v -s "$@"

# 5. Capture the exit status
RESULT=$?

if [ $RESULT -eq 0 ]; then
    echo ""
    echo "✅ All tests passed!"
else
    echo ""
    echo "❌ Some tests failed. Check the logs above."
fi

exit $RESULT