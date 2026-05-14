{
  pkgs,
  username,
  ...
}: {
  environment.systemPackages = with pkgs; [
    tangram
  ];

  home-manager.users.${username} = {lib, ...}: {
    dconf = {
      settings = with lib.hm.gvariant; {
        "re/sonny/Tangram" = {
          instances = lib.mkDefault [
            "v2raya"
            "qbittorrent"
            "comfyui"
            "kiwix"
          ];
        };
        "re/sonny/Tangram/instances/v2raya" = {
          name = "v2raya";
          url = "http://localhost:2017";
        };
        "re/sonny/Tangram/instances/qbittorrent" = {
          name = "qbittorrent";
          url = "http://127.0.0.1:8080";
        };
        "re/sonny/Tangram/instances/kiwix" = {
          name = "kiwix";
          url = "http://localhost:7777/#lang=eng";
        };
        "re/sonny/Tangram/instances/comfyui" = {
          name = "comfyui";
          url = "http://localhost:8188";
        };
      };
    };
  };
}
