{
  description = "Carlos Darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    nix-homebrew.url = "github:zhaofengli-wip/nix-homebrew";
    /*
      homebrew-core = {
      url = "github:homebrew/homebrew-core";
      flake = false;
      };
      homebrew-cask = {
      url = "github:homebrew/homebrew-cask";
      flake = false;
      };
    */
  };

  outputs = inputs@{ self, nix-darwin, nixpkgs, nix-homebrew /*, homebrew-core, homebrew-cask */ }:
    let
      configuration = { pkgs, config, ... }: {

        nixpkgs.config.allowUnfree = true;

        environment.systemPackages =
          [
            pkgs.eza
            pkgs.helix
            pkgs.awscli
            pkgs.bat
            pkgs.bun
            pkgs.deno
            pkgs.fzf
            pkgs.gh
            pkgs.go
            pkgs.gopls
            pkgs.httpie
            pkgs.hyperfine
            pkgs.mkalias
            pkgs.neofetch
            pkgs.nil
            pkgs.nixpkgs-fmt
            pkgs.nodejs
            pkgs.oh-my-zsh
            pkgs.onefetch
            pkgs.pnpm
            pkgs.postgresql
            pkgs.ruff
            pkgs.ruff-lsp
            pkgs.rustup
            pkgs.scc
            pkgs.speedtest-go
            pkgs.sqlfluff
            pkgs.starship
            pkgs.tailscale
            pkgs.taplo
            pkgs.terminal-notifier
            pkgs.terraform
            pkgs.timer
            pkgs.tmux
            pkgs.tokei
            pkgs.typst
            pkgs.uv
            pkgs.zsh-autosuggestions
            pkgs.zsh-syntax-highlighting
          ];

        homebrew = {
          enable = true;

          brews = [
            "mas"
          ];

          casks = [
            "alacritty"
            "cursor"
            "docker"
            "slack"
            "spotify"
            "tableplus"
            "visual-studio-code"
          ];

          masApps = {
            "tailscale" = 1475387142;
            "whatsapp" = 310633997;
          };

          onActivation.cleanup = "zap";
          onActivation.autoUpdate = true;
          onActivation.upgrade = true;
        };

        fonts.packages = [
          (pkgs.nerdfonts.override { fonts = [ "ComicShannsMono" ]; })
        ];

        system.defaults = {
          dock.autohide = false;
          dock.persistent-apps = [];
          finder.FXPreferredViewStyle = "clmv";
          loginwindow.GuestEnabled = false;
          NSGlobalDomain.AppleICUForce24HourTime = true;
          NSGlobalDomain.AppleInterfaceStyle = "Dark";
        };

        services.nix-daemon.enable = true;

        nix.settings.experimental-features = "nix-command flakes";

        programs.zsh = {
          enable = true;
          enableCompletion = true;
          interactiveShellInit = ''
            source ${pkgs.zsh-autosuggestions}/share/zsh-autosuggestions/zsh-autosuggestions.zsh
            source ${pkgs.zsh-syntax-highlighting}/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
          '';
        };

        system.configurationRevision = self.rev or self.dirtyRev or null;

        system.stateVersion = 5;

        nixpkgs.hostPlatform = "aarch64-darwin";
      };
    in
    {
      darwinConfigurations."mac-n-cheese" = nix-darwin.lib.darwinSystem {
        modules = [
          configuration
          nix-homebrew.darwinModules.nix-homebrew
          {
            nix-homebrew = {
              enable = true;

              enableRosetta = true;

              user = "carlos";

              autoMigrate = true;

              /*
              taps = {
                "homebrew/homebrew-core" = homebrew-core;
                "homebrew/homebrew-cask" = homebrew-cask;
              };

              mutableTaps = false;
              */
            };
          }
        ];
      };

      darwinPackages = self.darwinConfigurations."mac-n-cheese".pkgs;
    };
}
