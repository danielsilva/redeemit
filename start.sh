#!/bin/bash
# Start both API and frontend services using overmind

# Check if overmind is installed
if ! command -v overmind &> /dev/null; then
    echo "Error: overmind is not installed"
    echo "Install it with: brew install overmind"
    exit 1
fi

# Start overmind
overmind start