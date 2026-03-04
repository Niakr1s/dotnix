{
  config,
  lib,
  pkgs,
  inputs,
  nixpkgs-unstable,
  stateVersion,
  hostname,
  username,
  ...
}: let
in {
  programs.firefox = {
    enable = true;

    languagePacks = ["en-US"];

    profiles.default.extraConfig = ''
      // https://gist.github.com/lassekongo83/7026910c6a277d5d9cf37989d83e9f6d

      // Don't close window with last tab
      user_pref("browser.tabs.closeWindowWithLastTab", false);

      // Disable Firefox View
      user_pref("browser.tabs.firefox-view", false);

      // Disable disc cache
      user_pref("browser.cache.disk.enable", false);

      // Disable push notifications
      user_pref("dom.push.enabled", false);

      // Telemetry
      user_pref("browser.newtabpage.activity-stream.feeds.telemetry", false);
      user_pref("browser.newtabpage.activity-stream.telemetry", false);
      user_pref("browser.ping-centre.telemetry", false);
      user_pref("toolkit.telemetry.archive.enabled", false);
      user_pref("toolkit.telemetry.bhrPing.enabled", false);
      user_pref("toolkit.telemetry.enabled", false);
      user_pref("toolkit.telemetry.firstShutdownPing.enabled", false);
      user_pref("toolkit.telemetry.newProfilePing.enabled", false);
      user_pref("toolkit.telemetry.reportingpolicy.firstRun", false);
      user_pref("toolkit.telemetry.shutdownPingSender.enabled", false);
      user_pref("toolkit.telemetry.unified", false);
      user_pref("toolkit.telemetry.updatePing.enabled", false);

      // PREF: Disable sending reports of tab crashes to Mozilla (about:tabcrashed), don't nag user about unsent crash reports
      user_pref("browser.tabs.crashReporting.sendReport", false);
      user_pref("browser.crashReports.unsubmittedCheck.enabled", false);

      // Ads
      user_pref("browser.newtabpage.activity-stream.showSponsoredTopSites", false);
      user_pref("browser.newtabpage.activity-stream.showSponsored", false);
      user_pref("browser.vpn_promo.enabled", false);
      user_pref("browser.promo.focus.enabled", false);
    '';

    profiles.default.search = {
      force = true;
      default = "ddg";
      privateDefault = "ddg";

      engines = {
        "nix packages" = {
          urls = [
            {
              template = "https://search.nixos.org/packages";
              params = [
                {
                  name = "channel";
                  value = "unstable";
                }
                {
                  name = "query";
                  value = "{searchTerms}";
                }
              ];
            }
          ];
          icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
          definedAliases = ["@np"];
        };

        "nix options" = {
          urls = [
            {
              template = "https://search.nixos.org/options";
              params = [
                {
                  name = "channel";
                  value = "unstable";
                }
                {
                  name = "query";
                  value = "{searchTerms}";
                }
              ];
            }
          ];
          icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
          definedAliases = ["@no"];
        };

        "nixos wiki" = {
          urls = [
            {
              template = "https://wiki.nixos.org/w/index.php";
              params = [
                {
                  name = "search";
                  value = "{searchTerms}";
                }
              ];
            }
          ];
          icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
          definedAliases = ["@nw"];
        };

        "my nixos" = {
          urls = [
            {
              template = "https://mynixos.com/search";
              params = [
                {
                  name = "q";
                  value = "{searchTerms}";
                }
              ];
            }
          ];
          icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
          definedAliases = ["@nm"];
        };

        "youtube" = {
          urls = [
            {
              template = "https://www.youtube.com/results";
              params = [
                {
                  name = "search_query";
                  value = "{searchTerms}";
                }
              ];
            }
          ];
          definedAliases = ["@yt"];
        };
      };
    };
  };
}
