#!/bin/bash

MY_HOME_DIR="/Users/maia"
ZSH_CUSTOM="$MY_HOME_DIR/.oh-my-zsh/custom"

# Check if the script is run as root
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 
   exit 1
fi

# Install Homebrew
yes | /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" || { echo "Homebrew installation failed"; exit 1; }

# Add Homebrew to zprofile
echo -e "\n# Homebrew environment setup" >> $MY_HOME_DIR/.zprofile
echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> $MY_HOME_DIR/.zprofile

# Load Homebrew environment variables for the current shell session
eval "$(/opt/homebrew/bin/brew shellenv)"

# Install Visual Studio Code
brew install --cask visual-studio-code || { echo "Visual Studio Code installation failed"; exit 1; }

# Configure 'code' command to open VS Code from terminal
echo 'export PATH="$PATH:/Applications/Visual Studio Code.app/Contents/Resources/app/bin"' >> $MY_HOME_DIR/.zprofile

# Install Oh My Zsh
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" || { echo "Oh My Zsh installation failed"; exit 1; }

# Wait for Oh My Zsh installation to complete before proceeding
while [ ! -f $MY_HOME_DIR/.zshrc ]; do
  sleep 1
done

# Configure Zsh plugins
sed -i '' 's/plugins=(git)/plugins=(git zsh-autosuggestions zsh-syntax-highlighting fast-syntax-highlighting zsh-autocomplete)/' $MY_HOME_DIR/.zshrc

# Clone Zsh plugins into the proper directories
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting ${ZSH_CUSTOM}/plugins/zsh-syntax-highlighting
git clone https://github.com/zdharma/fast-syntax-highlighting ${ZSH_CUSTOM}/plugins/fast-syntax-highlighting
git clone https://github.com/marlonrichert/zsh-autocomplete ${ZSH_CUSTOM}/plugins/zsh-autocomplete

# Add aliases to the .zshrc file
echo "alias ll='ls -lah'" >> $MY_HOME_DIR/.zshrc
echo "alias k='kubectl'" >> $MY_HOME_DIR/.zshrc

# Install kubectl and wget
brew install kubectl wget || { echo "kubectl or wget installation failed"; exit 1; }

# Apply changes
source $MY_HOME_DIR/.zshrc
