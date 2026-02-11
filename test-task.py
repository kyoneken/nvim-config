#!/usr/bin/env python3
#MISE description = "Python test task"
#MISE depends = ["lint"]

#USAGE arg "input" help="Input file path"
#USAGE flag "--debug" help="Enable debug mode"

import sys

def main():
    """Main function for test task"""
    print("Running Python test task...")
    if len(sys.argv) > 1:
        print(f"Input: {sys.argv[1]}")
    
if __name__ == "__main__":
    main()
