{pkgs, ...}: {
  # VPN
  services.v2raya = {
    enable = true;
    package = pkgs.unstable.v2raya;
    cliPackage = pkgs.unstable.xray;
  };

  services.caddy = {
    enable = true;
    virtualHosts."http://v2raya.local" = {
      extraConfig = ''
        reverse_proxy localhost:2017
      '';
    };
  };

  networking.hosts = {
    "127.0.0.1" = [
      "v2raya.local"
    ];
  };
}
