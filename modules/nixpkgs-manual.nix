{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    nixpkgs-manual
  ];

  environment.shellAliases = {
    nixpkgs-help = "xdg-open ${pkgs.nixpkgs-manual}/share/doc/nixpkgs/index.html";
  };
}
