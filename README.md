# Description

My NixOS config motivated by [this](https://github.com/rPlakama/Elisheva/) repo.

## Structure

```
Hosts/           per-machine entry point (imports hardware.nix + Features)
Features/
├── Core/        always enabled: hardware & services shared across hosts
├── Desktops/    graphical sessions
└── Misc/        everything else
```

Feature dirs are **auto-imported** — drop any `.nix` file into a folder and it's picked up. Hosts enable features in `Hosts/<name>/default.nix`; each feature exposes `options.features.<name>.enable` gated by `config = mkIf cfg.enable`.
