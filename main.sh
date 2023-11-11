#!/bin/bash

MY_HOME_DIR=$HOME
ZSH_CUSTOM="$MY_HOME_DIR/.oh-my-zsh/custom"

# Ensure the script is not running as root
if [[ $EUID -eq 0 ]]; then
   echo "Do not run this script as root or using sudo!"
   exit 1
fi

# Install Homebrew (it will ask for the user's password if necessary)
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" 

# Add Homebrew to zprofile
echo -e "\n# Homebrew environment setup" >> $MY_HOME_DIR/.zprofile
echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> $MY_HOME_DIR/.zprofile

# Load Homebrew environment variables for the current shell session
eval "$(/opt/homebrew/bin/brew shellenv)"

# Check if Visual Studio Code is installed by looking for the application directory
if [ ! -d "/Applications/Visual Studio Code.app" ]; then
  echo "Visual Studio Code not found, installing..."
  brew install --cask visual-studio-code || { echo "Visual Studio Code installation failed"; exit 1; }
else
  echo "Visual Studio Code is already installed."
fi

cat << EOF >> ~/.zprofile
export PATH="\$PATH:/Applications/Visual Studio Code.app/Contents/Resources/app/bin"
EOF

# Configure 'code' command to open VS Code from terminal
echo 'export PATH="$PATH:/Applications/Visual Studio Code.app/Contents/Resources/app/bin"' >> $MY_HOME_DIR/.zprofile

# Check if oh-my-zsh
if [ -d "$MY_HOME_DIR/.oh-my-zsh" ]; then
  rm -rf $MY_HOME_DIR/.oh-my-zsh.bak
  mv $MY_HOME_DIR/.oh-my-zsh "$MY_HOME_DIR/.oh-my-zsh.bak"
  rm -rf $MY_HOME_DIR/.oh-my-zsh
fi

# Install Oh My Zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

# Configure Zsh plugins
sed -i '' 's/^plugins=(.*)/plugins=(git zsh-autosuggestions zsh-syntax-highlighting zsh-autocomplete)/' "$MY_HOME_DIR/.zshrc"

# Clone Zsh plugins into the proper directories
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting ${ZSH_CUSTOM}/plugins/zsh-syntax-highlighting
git clone https://github.com/marlonrichert/zsh-autocomplete ${ZSH_CUSTOM}/plugins/zsh-autocomplete

# Add aliases to the .zshrc file
echo "alias ll='ls -lah'" >> $MY_HOME_DIR/.zshrc
echo "alias k='kubectl'" >> $MY_HOME_DIR/.zshrc

# Install kubectl and wget
brew install kubectl wget jq python@3
