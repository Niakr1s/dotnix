{
  pkgs,
  username,
  ...
}:
{
  environment.systemPackages = with pkgs; [
    dotool
  ];

  # Load uinput kernel module
  boot.kernelModules = [ "uinput" ];

  # Create a dedicated group for uinput access
  users.groups.uinput = { };

  # udev rule - use the uinput group
  services.udev.extraRules = ''
    KERNEL=="uinput", GROUP="uinput", MODE="0660"
  '';

  # Add your user to BOTH groups (some dotool operations need input)
  users.users.${username} = {
    extraGroups = [
      "uinput"
      "input"
    ];
  };
}
