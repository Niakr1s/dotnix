{
  inputs,
  config,
  pkgs,
  username,
  flakeDir,
  ...
}: let
  cotpSopsPath = "common/security/cotp";
in {
  environment.variables = {
    COTP_DB_PATH = "${flakeDir}/secrets/db.cotp";
  };

  environment.systemPackages = with pkgs; [
    cotp
  ];

  sops.secrets = {
    # This is the actual specification of the secrets.
    "${cotpSopsPath}" = {
      mode = "0440";
      owner = config.users.users.${username}.name;
      group = config.users.users.${username}.group;
    };
  };

  # some common aliases
  environment.shellAliases = {
    cotp = "cat /run/secrets/${cotpSopsPath} | cotp --password-stdin";
  };
}
