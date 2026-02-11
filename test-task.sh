#!/bin/bash
#MISE description = "Test task with MISE comment"
#MISE depends = ["build"]

#USAGE arg "name" help="Your name"
#USAGE flag "--verbose" help="Enable verbose output"

# This is a sample mise task file
echo "Running test task..."

if [ -n "$1" ]; then
  echo "Hello, $1!"
else
  echo "Hello, World!"
fi
