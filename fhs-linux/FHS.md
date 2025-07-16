# Install paru

```
mkdir tmp
cd tmp
git clone https://aur.archlinux.org/paru
cd paru
makepkg -si
```

# Setup Git

```
paru -S google-chrome
ssh-keygen
```

# Programs

### Setup Nix

```
sudo nix-channel --add https://github.com/nixpkgs/home-manager/archive/master.tar.gz home-manager
sudo nix-channel --update
```
