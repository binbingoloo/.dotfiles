# 🍎 macOS Development Environment Setup Guide 2025

> A comprehensive guide to setting up a modern development environment on macOS with essential tools, terminal customization, and productivity applications.

## 📋 Table of Contents

- [🍎 macOS Development Environment Setup Guide 2025](#-macos-development-environment-setup-guide-2025)
  - [📋 Table of Contents](#-table-of-contents)
  - [🎯 Overview](#-overview)
    - [What's Included](#whats-included)
  - [🚀 Getting Started](#-getting-started)
    - [Xcode Command Line Tools](#xcode-command-line-tools)
    - [Homebrew Package Manager](#homebrew-package-manager)
  - [🖥️ Terminal Setup](#️-terminal-setup)
    - [Oh My Zsh](#oh-my-zsh)
    - [Powerlevel10k Theme](#powerlevel10k-theme)
    - [Zsh Plugins](#zsh-plugins)
      - [1. Zsh Completions](#1-zsh-completions)
      - [2. Zsh Autosuggestions](#2-zsh-autosuggestions)
      - [3. Zsh Syntax Highlighting](#3-zsh-syntax-highlighting)
    - [Terminal Fonts](#terminal-fonts)
  - [💻 Development Environment](#-development-environment)
    - [Language Version Managers](#language-version-managers)
    - [IDEs \& Development Tools](#ides--development-tools)
    - [CLI Power Tools](#cli-power-tools)
      - [Additional Setup](#additional-setup)
  - [🎨 Productivity Applications](#-productivity-applications)
  - [🔧 Dotfiles Configuration](#-dotfiles-configuration)

## 🎯 Overview

This guide provides a step-by-step approach to setting up a professional development environment on macOS. It covers everything from basic command-line tools to advanced terminal customization and productivity applications.

### What's Included

- ✅ Package management with Homebrew
- ✅ Beautiful and functional terminal with Oh My Zsh and Powerlevel10k
- ✅ Version managers for Node.js, Python, Java, and Rust
- ✅ Essential development tools and IDEs
- ✅ Powerful CLI utilities for enhanced productivity
- ✅ Dotfiles management

## 🚀 Getting Started

### Xcode Command Line Tools

First, install Xcode Command Line Tools which are required by many development tools:

```bash
xcode-select --install
```

**Required for:** Homebrew, Rust, Python native extensions, Git, and more.

### Homebrew Package Manager

Install [Homebrew](https://brew.sh/), the missing package manager for macOS:

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

Add Homebrew to your PATH:

```bash
echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
eval "$(/opt/homebrew/bin/brew shellenv)"
```

> 💡 **Tip:** Homebrew manages both CLI tools and GUI applications (via cask), providing a foundation for clean installs.

## 🖥️ Terminal Setup

### Oh My Zsh

Install [Oh My Zsh](https://github.com/ohmyzsh/ohmyzsh), a delightful framework for managing your Zsh configuration:

```bash
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
```

> ⚠️ **Note:** Oh My Zsh will overwrite your existing `~/.zshrc`. Make sure to append `.zshrc.pre-oh-my-zsh` to the new `~/.zshrc` if needed.

### Powerlevel10k Theme

Install [Powerlevel10k](https://github.com/romkatv/powerlevel10k), a fast and flexible Zsh theme:

```bash
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k"
```

Update your `~/.zshrc`:

```bash
ZSH_THEME="powerlevel10k/powerlevel10k"
```

Configure Powerlevel10k:

```bash
p10k configure
```

### Zsh Plugins

#### 1. Zsh Completions

Additional completion definitions for Zsh:

```bash
git clone https://github.com/zsh-users/zsh-completions.git \
  ${ZSH_CUSTOM:-${ZSH:-~/.oh-my-zsh}/custom}/plugins/zsh-completions
```

Add to `~/.zshrc` **before** sourcing oh-my-zsh:

```bash
# zsh-completions
fpath+=${ZSH_CUSTOM:-${ZSH:-~/.oh-my-zsh}/custom}/plugins/zsh-completions/src
autoload -U compinit && compinit

source $ZSH/oh-my-zsh.sh
```

#### 2. Zsh Autosuggestions

Fish-like autosuggestions for Zsh:

```bash
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
```

#### 3. Zsh Syntax Highlighting

Fish shell-like syntax highlighting:

```bash
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
```

Update plugins in `~/.zshrc`:

```bash
plugins=(
  git
  zsh-autosuggestions
  zsh-syntax-highlighting
)
```

### Terminal Fonts

Install Nerd Fonts for better terminal experience:

```bash
brew install --cask font-hack-nerd-font
brew install --cask font-jetbrains-mono-nerd-font
```

## 💻 Development Environment

### Language Version Managers

> 💡 **Best Practice:** Avoid installing Node, Python, or Java directly. Use version managers instead.

| Language    | Tool   | Installation                                                      | Configuration |
| ----------- | ------ | ----------------------------------------------------------------- | ------------- |
| **Node.js** | nvm    | `brew install nvm`                                                | See below     |
| **Python**  | pyenv  | `brew install pyenv`                                              | See below     |
| **Java**    | sdkman | `curl -s "https://get.sdkman.io/" \| bash`                        | See below     |
| **Rust**    | rustup | `curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs \| sh` | -             |

Add to your `~/.zshrc`:

```bash
# NVM
export NVM_DIR="$HOME/.nvm"
[ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"
[ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"

# Pyenv
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init --path)"
eval "$(pyenv init -)"

# SDKMAN - THIS MUST BE AT THE END OF THE FILE
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"
```

### IDEs & Development Tools

```bash
brew install --cask visual-studio-code
brew install --cask intellij-idea-ce
brew install --cask postman
```

### CLI Power Tools

Essential command-line tools for enhanced productivity:

| Tool          | Installation                  | Description                                |
| ------------- | ----------------------------- | ------------------------------------------ |
| **WezTerm**   | `brew install --cask wezterm` | GPU-accelerated terminal emulator          |
| **tmux**      | `brew install tmux`           | Terminal multiplexer for multiple sessions |
| **Neovim**    | `brew install neovim`         | Hyperextensible Vim-based text editor      |
| **zoxide**    | `brew install zoxide`         | Smart cd command with directory history    |
| **fzf**       | `brew install fzf`            | Fuzzy finder for files/history/search      |
| **fd**        | `brew install fd`             | Fast and user-friendly alternative to find |
| **ripgrep**   | `brew install ripgrep`        | Lightning-fast recursive file search       |
| **bat**       | `brew install bat`            | Cat clone with syntax highlighting         |
| **lsd**       | `brew install lsd`            | Modern ls with icons and colors            |
| **git-delta** | `brew install git-delta`      | Syntax-highlighting pager for git          |
| **jq**        | `brew install jq`             | Command-line JSON processor                |
| **lazygit**   | `brew install lazygit`        | Simple terminal UI for git commands        |
| **gh**        | `brew install gh`             | GitHub's official command line tool        |
| **htop/btop** | `brew install htop btop`      | Interactive process viewers                |

#### Additional Setup

**zoxide** - Add to `~/.zshrc`:

```bash
eval "$(zoxide init zsh)"
```

**fzf** - Run the install script:

```bash
$(brew --prefix)/opt/fzf/install
```

**fzf-tab** - Enhanced tab completions:

```bash
git clone https://github.com/Aloxaf/fzf-tab ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/fzf-tab
```

## 🎨 Productivity Applications

| Application   | Installation                          | Description                        |
| ------------- | ------------------------------------- | ---------------------------------- |
| **Notion**    | `brew install --cask notion`          | All-in-one workspace               |
| **Obsidian**  | `brew install --cask obsidian`        | Knowledge base with local Markdown |
| **Discord**   | `brew install --cask discord`         | Communication platform             |
| **Stats**     | `brew install --cask stats`           | System monitoring in menu bar      |
| **Ice**       | `brew install --cask jordanbaird-ice` | Menu bar organizer                 |
| **KeyCastr**  | `brew install --cask keycastr`        | Keystroke visualizer               |
| **Flameshot** | `brew install --cask flameshot`       | Screenshot and annotation tool     |

## 🔧 Dotfiles Configuration

Create symbolic links for your dotfiles:

```bash
# Create symlinks for configuration files
ln -sf $(pwd)/.zprofile ~/.zprofile
ln -sf $(pwd)/.zshrc ~/.zshrc
ln -sf $(pwd)/.vimrc ~/.vimrc
ln -sf $(pwd)/.tmux.conf ~/.tmux.conf
ln -sf $(pwd)/.p10k.zsh ~/.p10k.zsh
ln -sf $(pwd)/.gitmessage ~/.gitmessage
ln -sf $(pwd)/.gitconfig ~/.gitconfig
ln -sf $(pwd)/.fzf.zsh ~/.fzf.zsh
ln -sf $(pwd)/.editorconfig ~/.editorconfig
ln -sf $(pwd)/.config/nvim ~/.config/nvim
ln -sf $(pwd)/.config/lazygit/config.yml ~/Library/Application\ Support/lazygit/config.yml
ln -sf $(pwd)/.config/bat ~/.config/bat
ln -sf $(pwd)/.config/lsd ~/.config/lsd
ln -sf $(pwd)/.config/wezterm ~/.config/wezterm
```

---
