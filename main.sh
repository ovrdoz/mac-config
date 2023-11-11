#!/bin/bash

# brew install
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

echo "write homebrew to zprofile"
(echo; echo 'eval "$(/opt/homebrew/bin/brew shellenv)"') >> /Users/maia/.zprofile

echo "set shellenv for homebrew"
eval "$(/opt/homebrew/bin/brew shellenv)"
