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
  services.openssh = {
    enable = true;
    ports = [5432];
    settings = {
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
      PermitRootLogin = "no";
      AllowUsers = ["${username}"];
    };
  };

  programs.ssh = {
    extraConfig = ''
      Host github.com
        IdentitiesOnly yes
        IdentityFile ~/.ssh/id_ed25519
      Host desktop
        Hostname 192.168.1.11
        Port 5432
        User ${username}
      Host laptop
        Hostname 192.168.1.12
        Port 5432
        User ${username}
    '';
  };

  users.users."${username}".openssh = {
    authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIA5vWOuf5yFVKDQX08zvuw1thG88NhBIVkrvbzoL4/25 nea@desktop"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKISELrDRXz1FWCjaspsAjENSWBRJnU8DxFRav7mFuPq nea@laptop"
    ];
  };
}
