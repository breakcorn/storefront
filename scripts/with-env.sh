#!/bin/bash
# Execute command with loaded .env file
# Usage: scripts/with-env.sh [environment] -- [command]

set -e

# Parse arguments
ENV="development"
COMMAND_START=1

# Check if first argument is environment
if [[ "$1" =~ ^(development|production|test)$ ]]; then
    ENV="$1"
    shift
    COMMAND_START=2
fi

# Skip -- if present
if [ "$1" = "--" ]; then
    shift
fi

# Check if command is provided
if [ $# -eq 0 ]; then
    echo "Usage: $0 [environment] [--] command [args...]"
    echo "Environments: development, production, test"
    exit 1
fi

# Load environment
echo "🔄 Loading $ENV environment..."
source "$(dirname "$0")/load-env.sh" "$ENV"

# Execute command with environment preserved
echo "🚀 Executing: $@"
"$@"
