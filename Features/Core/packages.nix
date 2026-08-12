{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
let
  inherit (lib) optionals;
  gpu = config.core.gpu;
  user = config.core.user;
in
{
  environment.systemPackages = with pkgs; [
    cifs-utils
    man-pages-posix
    man-pages
  ];

  hjem.users.${user} = {
    packages =
      with pkgs;
      [
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
      ]
      ++ optionals (!gpu.nvidia) [ btop-rocm ]
      ++ optionals gpu.nvidia [ btop-cuda ];
  };
}
