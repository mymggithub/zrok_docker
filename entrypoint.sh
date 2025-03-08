#!/bin/sh

# Validate ZROK_TOKEN
if [ -z "$ZROK_TOKEN" ]; then
  echo "[ERROR]: ZROK_TOKEN is not set."
  exit 1
fi

echo "Checking for existing enabled environment..."
if zrok status > /dev/null 2>&1; then
  echo "Disabling existing environment..."
  zrok disable 2>error.log
  if [ $? -ne 0 ]; then
    echo "[ERROR]: Failed to disable existing environment. Check error.log for details."
    cat error.log
    exit 1
  fi
fi

echo "Enabling ZROK_TOKEN..."
zrok enable "$ZROK_TOKEN" 2>error.log
if [ $? -ne 0 ]; then
  echo "[ERROR]: Failed to enable ZROK_TOKEN. Check error.log for details."
  cat error.log
  exit 1
fi

echo "Starting zrok share..."
exec zrok share public n8n:5678