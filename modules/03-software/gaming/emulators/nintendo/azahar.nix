{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    azahar
  ];
}
