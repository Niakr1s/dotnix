{inputs, ...}: let
  libraryPath = "/data/hdd1/kiwix/library.xml";
in {
  imports = ["${inputs.nixpkgs-unstable}/nixos/modules/services/misc/kiwix-serve.nix"];

  services.kiwix-serve = {
    enable = true;
    port = 7777;
    libraryPath = "${libraryPath}";
  };

  services.caddy = {
    enable = true;
    virtualHosts."http://kiwix.local" = {
      extraConfig = ''
        reverse_proxy localhost:7777
      '';
    };
  };

  networking.hosts = {
    "127.0.0.1" = [
      "kiwix.local"
    ];
  };
}
