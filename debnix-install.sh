#!/usr/bin/env bash
# sudo dpkg-reconfigure console-setup (UFT-8, Latin1, Terminus, 16x32)
# https://www.youtube.com/watch?v=RoMArT8UCKM Flakes for beginners
# https://www.youtube.com/watch?v=hLxyENmWZSQ Getting started with Nix Home Manager WSL

# Scripts/Configs that could also work:
# https://github.com/mikepruett3/debian-hyprland
# https://github.com/arkboix/debian-hyprland
# https://github.com/leepeter99/Debian-Hyprland-withNixHome
# https://github.com/JaKooLit/Debian-Hyprland.git
# https://github.com/RoastBeefer00/nix-home.git

set -e  # Exit on error

# Install Curl, zram-tools,git,micro(want?)
echo "🛠 Installing Requirements for the script..."
sudo apt update
sudo apt upgrade
sudo apt-get install curl git sddm build-essential -y

# Install Nix
echo "🛠 Installing Nix package manager..."
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install --no-confirm

# Activate Nix environment
echo "🔌 Activating Nix environment..."
source /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh

# Install Home Manager
echo "🚀 Setting up and Installing Home Manager..."
nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager
nix-channel --update
nix-shell '<home-manager>' -A install

# Create configuration directory
echo "📂 Creating configuration directory..."
mkdir -p ~/.config/home-manager

# Install Nix
echo "🛠 Installing nixGLDefault..."
nix-channel --add https://github.com/nix-community/nixGL/archive/main.tar.gz nixgl && nix-channel --update
nix-env -iA nixgl.auto.nixGLDefault
#nix-env -iA nixgl.nixGLIntel

echo "📝 Cloning config from repo..."
git clone https://github.com/miguelgranja/debnix.git
# git clone https://github.com/RoastBeefer00/nix-home.git

echo "🏡 Making adjustmenst to the repo..."
# grep -lR "roastbeefer" nix-home/ | xargs sed -i 's/roastbeefer/miguel/g'
# cd nix-home
cd debnix

# Copy these files to your home config
echo "📂 Copying repo configuration to config directory..."
cp -r * ~/.config/home-manager
cp .zshrc ~/.config/home-manager
cp waves.jpg ~/Pictures

#Create an SDDM entry for Hyprland
echo "📂 Creating an SDDM entry for Hyprland..."
sudo mkdir -p /usr/share/wayland-sessions/
echo '[Desktop Entry]
Exec=nixGL Hyprland
Name=Hyprland' | sudo tee /usr/share/wayland-sessions/hyprland.desktop

# Build the configuration
echo "🔨 Building configuration..."
home-manager switch --flake ~/.config/home-manager#$USER

echo "🎉 Installation complete! Log out and back in to start using Hyprland."
