{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    nixpkgs-manual
  ];

  environment.shellAliases = {
    nixpkgs-manual = "xdg-open ${pkgs.nixpkgs-manual}/share/doc/nixpkgs/index.html";
  };
}
