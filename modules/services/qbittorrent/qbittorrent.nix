{
  inputs,
  config,
  lib,
  pkgs,
  hostname,
  unstablePkgs,
  username,
  ...
}: let
  categories_json = lib.replaceStrings ["\n"] ["\\n"] ''
    {
        "Books": {
            "save_path": ""
        },
        "Games": {
            "save_path": ""
        },
        "Soft": {
            "save_path": ""
        },
        "Video": {
            "save_path": ""
        },
        "Video/Anime": {
            "save_path": ""
        },
        "Video/Movies": {
            "save_path": ""
        },
        "Video/Series": {
            "save_path": ""
        }
    }
  '';
  watched_folders_json = lib.replaceStrings ["\n"] ["\\n"] ''
    {
      "/home/${username}/Downloads": {
        "add_torrent_params": {
          "category": "",
          "download_limit": -1,
          "download_path": "",
          "inactive_seeding_time_limit": -2,
          "operating_mode": "AutoManaged",
          "ratio_limit": -2,
          "save_path": "",
          "seeding_time_limit": -2,
          "share_limit_action": "Default",
          "skip_checking": false,
          "ssl_certificate": "",
          "ssl_dh_params": "",
          "ssl_private_key": "",
          "tags": [],
          "upload_limit": -1
        },
        "recursive": false
      }
    }
  '';
in {
  services.qbittorrent = {
    enable = true;
    user = "${username}";
    group = "users";
    openFirewall = true;
    torrentingPort = 6881;
    webuiPort = 8080;
    serverConfig = {
      BitTorrent = {
        Session = {
          DefaultSavePath = "/home/${username}/Torrents"; # systemd will create this directory for us
          TempPath = "/home/${username}/Torrents/.tmp";
          TorrentExportDirectory = "/home/${username}/Torrents/.torrents";
          AlternativeGlobalDLSpeedLimit = 6000;
          DisableAutoTMMByDefault = false;
          GlobalMaxRatio = 0; # stop seeding imediatly
          ShareLimitAction = "Stop";
          QueueingSystemEnabled = false;
          SubcategoriesEnabled = true;
        };
      };
      Core = {
        AutoDeleteAddedTorrentFile = "IfAdded";
      };
      Preferences = {
        WebUI = {
          Username = "${username}";
          Password_PBKDF2 = "@ByteArray(agI2Tr50yXx8i5Gm9kTfkA==:79jfEujByGcX3FQTbLt2IIm4t7pSxfQhwVIcVFOlTKLtJ1XIJPnDN28+w2udq2ksKpr3UUjxKoCYO6WzaiT+8w==)";
          LocalHostAuth = false;
        };
      };
    };
  };

  # man tmpfiles.d
  systemd.tmpfiles.rules = [
    "d /home/${username}/Torrents 0755 ${username} users - -"
    "f+ /var/lib/qBittorrent/qBittorrent/config/categories.json 0644 ${username} users - ${categories_json}"
    "f+ /var/lib/qBittorrent/qBittorrent/config/watched_folders.json 0644 ${username} users - ${watched_folders_json}"
  ];

  systemd.services.qbittorrent.serviceConfig.ProtectHome = lib.mkForce "read-write";
}
