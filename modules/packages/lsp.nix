{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.modules.cli.lsp;

  inherit (lib) optionals;

  baseServersPkgs = with pkgs; [
    nil
    nixd
    lua-language-server
    bash-language-server
    ruff
    pyright
    typescript-language-server
    vscode-langservers-extracted # предоставляет jsonls, html, cssls
    yaml-language-server
    marksman
    docker-language-server
    taplo
    lemminx
    sqls
  ];

  heavyServersPkgs = with pkgs; [
    clang-tools
    kotlin-language-server
    rust-analyzer
    gopls
    omnisharp-roslyn
    jdt-language-server
    phpactor
    crystalline
  ];

in
{
  environment.systemPackages = optionals (cfg.base) baseServersPkgs ++ optionals (cfg.heavy) heavyServersPkgs;
}
