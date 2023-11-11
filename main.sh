#!/bin/bash

# brew install
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

(echo; echo 'eval "$(/opt/homebrew/bin/brew shellenv)"') >> /Users/maia/.zprofile
eval "$(/opt/homebrew/bin/brew shellenv)"
