#!/usr/bin/env bash

# Function to check if a command exists
check_command() {
  command -v "$1" >/dev/null 2>&1
}

# Check if Docker is installed
if ! check_command docker; then
  echo "Docker is not installed. Please install Docker."
  exit 1
fi

# Check if Docker is running (alternative for systems without systemctl)
if ! docker info >/dev/null 2>&1; then
  echo "Docker is installed but not running. Please start Docker."
  exit 1
fi

# Check if Go is installed
if ! check_command go; then
  echo "Go is not installed. Please install Go."
  exit 1
fi
