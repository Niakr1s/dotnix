{
  inputs,
  config,
  lib,
  pkgs,
  hostname,
  unstablePkgs,
  username,
  ...
}: {
  services.qbittorrent = {
    enable = true;
    openFirewall = true;
    torrentingPort = 6881;
    webuiPort = 8080;
    serverConfig = {
      BitTorrent = {
        Session = {
          DefaultSavePath = "/srv/torrents"; # systemd will create this directory for us
          TempPath = "/srv/torrents/temp";
          # TorrentExportDirectory = "/srv/torrents/.torrents";
          AlternativeGlobalDLSpeedLimit = 6000;
          DisableAutoTMMByDefault = false;
          GlobalMaxRatio = 1; # stop seeding after ratio 1
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
    "R /var/lib/qBittorrent/qBittorrent/config/categories.json - - - - -"
    "C /var/lib/qBittorrent/qBittorrent/config/categories.json 0644 qbittorrent qbittorrent - /home/${username}/.dotnix/config/qBittorrent/config/categories.json"
    "R /var/lib/qBittorrent/qBittorrent/config/watched_folders.json - - - - -"
    "C /var/lib/qBittorrent/qBittorrent/config/watched_folders.json 0644 qbittorrent qbittorrent - /home/${username}/.dotnix/config/qBittorrent/config/watched_folders.json"
    "d /srv/torrents 2770 qbittorrent qbittorrent - -"
    "d /srv/torrents/autoload 2770 qbittorrent qbittorrent - -"
  ];

  users.users.${username}.extraGroups = ["qbittorrent"];
}
