{pkgs, ...}: {
  imports = [
    ../../modules/gaming/retroarch/retroarch.nix
    ../../modules/gaming/azahar/azahar.nix
  ];

  environment.systemPackages = with pkgs; [
    openttd # clone of "Transport Tycoon Deluxe"
    zeroad # 0ad
    wesnoth # turn based strategy
    widelands # settlers
  ];
}
