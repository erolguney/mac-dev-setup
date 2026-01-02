#!/usr/bin/env bash
# mac-dev-setup.sh - One-command Mac developer environment setup
set -euo pipefail

# Parse arguments
DRY_RUN=false
for arg in "$@"; do
  case $arg in
    --dry-run|-d)
      DRY_RUN=true
      ;;
    --help|-h)
      echo "Usage: ./mac-dev-setup.sh [OPTIONS]"
      echo ""
      echo "Options:"
      echo "  --dry-run, -d    Show what would be done without making changes"
      echo "  --help, -h       Show this help message"
      exit 0
      ;;
  esac
done

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES_DIR="$REPO_DIR/dotfiles"

echo ""
echo "╔════════════════════════════════════════╗"
if $DRY_RUN; then
echo "║         mac-dev-setup (DRY RUN)        ║"
else
echo "║         mac-dev-setup                  ║"
fi
echo "╚════════════════════════════════════════╝"
echo ""
echo "Repo: $REPO_DIR"
if $DRY_RUN; then
  echo "Mode: DRY RUN (no changes will be made)"
fi
echo ""

BACKUP_DIR="$HOME/.dotfiles_backup/$(date +%Y%m%d_%H%M%S)"

link_file() {
  local src="$1"
  local dest="$2"

  if $DRY_RUN; then
    if [[ -e "$dest" && ! -L "$dest" ]]; then
      echo "  [dry-run] Would backup: $dest"
    fi
    echo "  [dry-run] Would link: $dest -> $src"
    return
  fi

  if [[ -e "$dest" && ! -L "$dest" ]]; then
    echo "  Backing up: $dest"
    mkdir -p "$BACKUP_DIR"
    mv "$dest" "$BACKUP_DIR/" || true
  fi

  mkdir -p "$(dirname "$dest")"
  ln -sfn "$src" "$dest"
  echo "  ✓ $dest"
}

# 1) Xcode Command Line Tools
echo "▸ Checking Xcode Command Line Tools..."
if xcode-select -p >/dev/null 2>&1; then
  echo "  ✓ Already installed"
else
  if $DRY_RUN; then
    echo "  [dry-run] Would install Xcode Command Line Tools"
  else
    echo "  ✗ Not found, installing..."
    xcode-select --install
    echo ""
    echo "  Waiting for Xcode CLI tools installation to complete..."
    echo "  Press any key once the installation is finished."
    read -n 1 -s
  fi
fi

# 2) Homebrew
echo ""
echo "▸ Checking Homebrew..."
if command -v brew >/dev/null 2>&1; then
  echo "  ✓ Already installed"
else
  if $DRY_RUN; then
    echo "  [dry-run] Would install Homebrew"
  else
    echo "  ✗ Not found, installing..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  fi
fi

# Ensure brew is in PATH for Apple Silicon
if [[ -x /opt/homebrew/bin/brew ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

echo ""
echo "▸ Updating Homebrew..."
if $DRY_RUN; then
  echo "  [dry-run] Would run: brew update"
else
  brew update
fi

# 3) Brewfile packages
echo ""
echo "▸ Checking Brewfile..."
if [[ -f "$REPO_DIR/Brewfile" ]]; then
  echo "  Found: $REPO_DIR/Brewfile"
  if $DRY_RUN; then
    echo "  [dry-run] Would install packages from Brewfile:"
    grep -E "^(brew|cask|tap) " "$REPO_DIR/Brewfile" | head -20
    echo "  ... (see Brewfile for full list)"
  else
    echo "  Installing packages..."
    echo ""
    brew bundle --file="$REPO_DIR/Brewfile"
  fi
else
  echo "  ✗ No Brewfile found, skipping"
fi

# 4) Oh My Zsh
echo ""
echo "▸ Checking Oh My Zsh..."
if [[ -d "$HOME/.oh-my-zsh" ]]; then
  echo "  ✓ Already installed"
else
  if $DRY_RUN; then
    echo "  [dry-run] Would install Oh My Zsh"
  else
    echo "  ✗ Not found, installing..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
  fi
fi

# 5) Alacritty themes
echo ""
echo "▸ Checking Alacritty themes..."
ALACRITTY_THEMES_DIR="$HOME/.config/alacritty/themes"
if [[ -d "$ALACRITTY_THEMES_DIR" ]]; then
  echo "  ✓ Already cloned"
else
  if $DRY_RUN; then
    echo "  [dry-run] Would clone alacritty-theme to $ALACRITTY_THEMES_DIR"
  else
    echo "  ✗ Not found, cloning..."
    mkdir -p "$HOME/.config/alacritty"
    git clone --quiet https://github.com/alacritty/alacritty-theme "$ALACRITTY_THEMES_DIR"
    echo "  ✓ Cloned to $ALACRITTY_THEMES_DIR"
  fi
fi

# 6) Symlink dotfiles
echo ""
echo "▸ Symlinking dotfiles..."

for f in .zshrc .zprofile .gitconfig; do
  if [[ -f "$DOTFILES_DIR/$f" ]]; then
    link_file "$DOTFILES_DIR/$f" "$HOME/$f"
  fi
done

if [[ -f "$DOTFILES_DIR/config/git/ignore" ]]; then
  link_file "$DOTFILES_DIR/config/git/ignore" "$HOME/.config/git/ignore"
fi

if [[ -f "$DOTFILES_DIR/config/alacritty/alacritty.toml" ]]; then
  link_file "$DOTFILES_DIR/config/alacritty/alacritty.toml" "$HOME/.config/alacritty/alacritty.toml"
fi

# Done
echo ""
echo "╔════════════════════════════════════════╗"
if $DRY_RUN; then
echo "║         Dry run complete               ║"
else
echo "║            Done!                       ║"
fi
echo "╚════════════════════════════════════════╝"
echo ""

if $DRY_RUN; then
  echo "Run without --dry-run to apply changes."
else
  echo "Next steps:"
  echo "  1. Restart your terminal (or run: source ~/.zshrc)"
  echo "  2. Your Nerd Font (UbuntuMono) should now be installed"
  if [[ -d "$BACKUP_DIR" ]]; then
    echo ""
    echo "Backed up existing files to: $BACKUP_DIR"
  fi
fi
echo ""
