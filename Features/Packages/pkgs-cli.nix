{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) optionals;
  gpu = config.core.gpu;
in
{
  environment.systemPackages = with pkgs; [
    cifs-utils
    man-pages-posix
    man-pages
    pciutils
    ripgrep
    zip
    yazi
    wget
    age
    sops
    fzf
    git
    unzip
    p7zip-rar
    unrar
    dust
    jq
    fd
    unar
    fastfetch cmatrix cowsay
    wl-clipboard
    nvtopPackages.full
    tealdeer
    lazygit
    lazysql
    chezmoi
    borgbackup
  ]
    ++ optionals (!gpu.nvidia) [ btop-rocm ]
    ++ optionals gpu.nvidia [ btop-cuda ];
}
