{pkgs, ...}: {
  imports = [
    ../../modules/gaming
  ];

  environment.systemPackages = with pkgs; [
    openttd # clone of "Transport Tycoon Deluxe"
    zeroad # 0ad
    wesnoth # turn based strategy
    widelands # settlers
  ];
}
