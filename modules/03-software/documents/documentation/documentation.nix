{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    man-pages
    man-pages-posix

    nixpkgs-manual
  ];

  documentation = {
    nixos = {
      enable = true;
      includeAllModules = true;
      checkRedirects = true;
    };

    doc.enable = true;
    dev.enable = true;

    man = {
      mandoc.enable = true;
      # Note: man-db must be disabled when using mandoc
      man-db.enable = false;

      cache = {
        enable = true;
      };
    };
  };

  environment.shellAliases = {
    nixpkgs-help = "xdg-open ${pkgs.nixpkgs-manual}/share/doc/nixpkgs/index.html";
  };
}
