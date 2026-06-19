{ pkgs, ... }:
{
  programs.bat = {
    enable = true;

    extraPackages = with pkgs.bat-extras; [
      batdiff
      batman
    ];

    settings = {
      theme = "TwoDark";
      style = "plain";
      paging = "always";
    };
  };
}
