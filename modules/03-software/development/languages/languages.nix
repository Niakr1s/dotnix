{
  pkgs,
  flakeLib,
  username,
  ...
}: {
  environment.systemPackages = with pkgs; [
    # --- Language Toolchains & Compilers (original) ---
    gcc # GNU C/C++ compiler
    clang-tools # glangd and other
    go # Go language and tools
    nodejs # Node.js
    bun # Node.js alternative
    python3 # Python 3 interpreter
    rustc # Rust compiler
    cargo # Rust's build system & package manager

    # --- Essential Build & Dev Tools (original) ---
    cmake # Cross-platform build system
    gnumake # GNU Make build automation
    git # Version control system
    ninja # Small build system

    # --- Additional Languages (original) ---
    zig # Zig compiler
    lua # Lua interpreter
    # ocaml # OCaml compiler

    # ========== NEW POPULAR LANGUAGES ==========

    # --- Java & JVM Languages ---
    openjdk21 # Java Development Kit (JDK) 21 LTS
    maven # Build automation tool for Java
    gradle # Another popular Java build tool
    kotlin # Kotlin compiler & runtime
    # scala # Scala language (runs on JVM)
    # sbt # Scala build tool

    # --- Ruby ---
    ruby # Ruby interpreter
    # bundler # Ruby dependency manager (gem bundler)

    # --- PHP ---
    php # PHP interpreter (latest stable)

    # --- Functional & Systems Programming ---
    ghc # Glasgow Haskell Compiler
    # cabal-install # Haskell build tool (cabal)
    # stack # Alternative Haskell build tool
    elixir # Elixir language (runs on Erlang VM)
    # erlang # Erlang VM and runtime
    # rebar3 # Erlang/Elixir build tool
    crystal # Crystal language (Ruby‑like syntax, compiled)
    nim # Nim language (efficient, expressive)
    # dmd # D language reference compiler

    # --- Web & Scripting (more) ---
    perl # Perl 5 interpreter
    # tcl # Tcl scripting language
    # racket # Racket language (Scheme descendant)
    # clojure # Clojure (JVM Lisp)

    # --- Build Tooling Additions (extended) ---
    # meson # High‑performance build system
    # bazel # Google’s build tool (multi‑language)
    # buck2 # Meta’s build system (advanced)
    # just # Command runner (like make but simpler)

    # --- Package Managers & Version Managers (extra) ---
    uv
  ];

  imports = [
    (flakeLib.mkHomeLink ".npmrc")
  ];

  home-manager.users.${username} = {config, ...}: {
    home.sessionPath = [
      "/home/${username}/.local/npm/bin"
    ];
  };
}
