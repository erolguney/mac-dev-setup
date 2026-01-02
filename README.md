# mac-dev-setup

Automated MacBook developer setup — one command to install everything.

## Quick Start

```bash
git clone https://github.com/<YOUR_USERNAME>/mac-dev-setup.git ~/mac-dev-setup
cd ~/mac-dev-setup
chmod +x mac-dev-setup.sh
./mac-dev-setup.sh
```

## What It Does

1. Installs **Xcode Command Line Tools** (if missing)
2. Installs **Homebrew**
3. Installs packages from **Brewfile** (CLI tools, apps, fonts)
4. Installs **Oh My Zsh**
5. Clones **Alacritty themes**
6. Symlinks **dotfiles** to home directory

## Key Tools Installed

| Category | Tools |
|----------|-------|
| Terminal | Alacritty + UbuntuMono Nerd Font + Gruvbox Dark |
| Shell | zsh + Oh My Zsh |
| Editor | Zed |
| IDE | Cursor |
| Node.js | fnm, pnpm |
| Python | uv |
| Git | git-delta, gh, lazygit |

## Customization

**Update git identity** — edit `dotfiles/.gitconfig`

**Add/remove packages** — edit `Brewfile`

## Files

```
mac-dev-setup.sh    # Run this on a new Mac
Brewfile            # All Homebrew packages
dotfiles/           # Config files (.zshrc, .gitconfig, alacritty, etc.)
```

## License

MIT
