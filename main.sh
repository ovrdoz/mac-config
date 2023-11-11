#!/bin/bash

MY_HOME_DIR="/Users/maia"
# Instala o Homebrew
yes | /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Adiciona Homebrew ao zprofile
echo -e "\n# Homebrew environment setup" >> $MY_HOME_DIR/.zprofile
echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> $MY_HOME_DIR/.zprofile

# Carrega as variáveis de ambiente do Homebrew para a sessão atual do shell
eval "$(/opt/homebrew/bin/brew shellenv)"

# Instala o Visual Studio Code
brew install --cask visual-studio-code

# Configura o comando 'code' para abrir o VS Code do terminal
cat << EOF >> $MY_HOME_DIR/.zprofile
# Add Visual Studio Code (code)
export PATH="\$PATH:/Applications/Visual Studio Code.app/Contents/Resources/app/bin"
EOF

# Instala o Oh My Zsh
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Configura plugins do Zsh (isso substituirá qualquer configuração existente de plugins no .zshrc)
sed -i '' 's/^plugins=(git)/plugins=(git zsh-autosuggestions zsh-syntax-highlighting fast-syntax-highlighting zsh-autocomplete)/' $MY_HOME_DIR/.zshrc

# Após instalar o Oh My Zsh, os plugins precisam ser clonados nos diretórios apropriados
git clone https://github.com/zsh-users/zsh-autosuggestions \${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting \${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
git clone https://github.com/zdharma/fast-syntax-highlighting \${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/fast-syntax-highlighting
git clone https://github.com/marlonrichert/zsh-autocomplete \${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autocomplete

# Recarrega o arquivo .zshrc para ativar os plugins
source $MY_HOME_DIR/.zshrc
