{
  inputs,
  config,
  pkgs,
  username,
  flakeDir,
  ...
}: let
  name = "Pavel";
  gmail = {
    pavel2188 = {
      address = "pavel2188@gmail.com";
      sops = "common/mail/gmail/pavel2188";
    };
  };
in {
  environment.variables = {
  };

  environment.systemPackages = with pkgs; [
    neomutt
    isync # for mbsync
    msmtp # for sending mail
  ];

  sops.secrets = {
    "${gmail.pavel2188.sops}" = {
      mode = "0440";
      owner = config.users.users.${username}.name;
      group = config.users.users.${username}.group;
    };
  };

  # some common aliases
  environment.shellAliases = {
  };

  home-manager.users.${username} = {
    # Email account configuration
    accounts.email = {
      # Base directory for all mail
      maildirBasePath = "Mail";

      accounts = {
        "${gmail.pavel2188.address}" = {
          # Basic account info
          realName = name;
          address = gmail.pavel2188.address;
          userName = gmail.pavel2188.address; # Gmail uses full email as username
          passwordCommand = "cat /run/secrets/${gmail.pavel2188.sops}";

          # Gmail-specific flavor - this sets correct defaults for Gmail
          flavor = "gmail.com";

          # NeoMutt integration
          neomutt = {
            enable = true;
          };

          # Configure mbsync to download emails
          mbsync = {
            enable = true;
            create = "maildir"; # Create maildirs locally
            expunge = "both"; # Sync deletions both ways
          };

          # Configure msmtp for sending
          msmtp = {
            enable = true;
          };

          primary = true; # Make this the default account
        };
      };
    };

    # Enable sync service
    programs.mbsync = {
      enable = true;
    };

    # Enable sync service
    services.mbsync = {
      enable = true;
      frequency = "*:0/5"; # Sync every 5 minutes
    };

    # Global NeoMutt configuration
    programs.neomutt = {
      enable = true;
      vimKeys = true; # Use vim-style keybindings
      sort = "reverse-date";
      checkStatsInterval = 60; # Check for new mail every minute
    };
  };
}
