# My dotfiles

> OS: macOS Ventura

First, install `nix`.

```shell
sh <(curl -L https://nixos.org/nix/install)
```

Then, symlink files.

```shell
chmod +x symlink.sh
./symlink.sh
```

Finally, install all packages with.

```shell
nix run nix-darwin -- switch --flake ~/.config/nix --impure
```
