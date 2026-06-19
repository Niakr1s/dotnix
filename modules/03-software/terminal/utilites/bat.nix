{ pkgs, ... }:
{
  # some common aliases
  # environment.shellAliases = {
  #   man = "batman";
  #   diff = "batdiff";
  # };

  programs.bat = {
    enable = true;

    extraPackages = with pkgs.bat-extras; [
      batdiff
      batman
    ];

    settings = {
      theme = "TwoDark";
      style = "plain";
    };
  };
}
