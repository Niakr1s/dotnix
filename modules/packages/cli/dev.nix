{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) optionals;

  cfg = config.modules.packages.cli.dev;

  langs = {
    cpp = with pkgs; [
      gcc # GNU C/C++ compiler
      clang-tools # glangd and other
    ];
    go = with pkgs; [
      go # Go language and tools
    ];
    haskell = with pkgs; [
      ghc # Glasgow Haskell Compiler
      cabal-install # Haskell build tool (cabal)
      stack # Alternative Haskell build tool
    ];
    java = with pkgs; [
      openjdk21 # Java Development Kit (JDK) 21 LTS
      kotlin # Kotlin compiler & runtime
      maven # Build automation tool for Java
      gradle # Another popular Java build tool
    ];
    lua = with pkgs; [
      lua # Lua interpreter
    ];
    node = with pkgs; [
      nodejs # Node.js
      bun # Node.js alternative
    ];
    perl = with pkgs; [
      perl
    ];
    php = with pkgs; [
      php # PHP interpreter (latest stable)

    ];
    python = with pkgs; [
      python3 # Python 3 interpreter
      uv
    ];
    ruby = with pkgs; [
      ruby # Ruby interpreter
      bundler # Ruby dependency manager (gem bundler)
    ];
    rust = with pkgs; [
      rustc # Rust compiler
      cargo # Rust's build system & package manager
    ];
    zig = with pkgs; [
      zig # Zig compiler
    ];

    bundles = {
      functional = with pkgs; [
        elixir # Elixir language (runs on Erlang VM)
        crystal # Crystal language (Ruby‑like syntax, compiled)
        nim # Nim language (efficient, expressive)
      ];
    };
  };
  buildtools = with pkgs; [
    cmake # Cross-platform build system
    gnumake # GNU Make build automation
    ninja # Small build system
    pkg-config
  ];
in
{
  environment.systemPackages =
    [ ]
    ++ optionals cfg.buildtools buildtools

    ++ optionals cfg.langs.bundles.functional langs.bundles.functional

    ++ optionals cfg.langs.cpp langs.cpp
    ++ optionals cfg.langs.go langs.go
    ++ optionals cfg.langs.haskell langs.haskell
    ++ optionals cfg.langs.java langs.java
    ++ optionals cfg.langs.lua langs.lua
    ++ optionals cfg.langs.node langs.node
    ++ optionals cfg.langs.perl langs.perl
    ++ optionals cfg.langs.php langs.php
    ++ optionals cfg.langs.python langs.python
    ++ optionals cfg.langs.ruby langs.ruby
    ++ optionals cfg.langs.rust langs.rust
    ++ optionals cfg.langs.zig langs.zig;
}
