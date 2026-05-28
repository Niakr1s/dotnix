{ pkgs, ... }:
{
  services.avahi = {
    enable = true;
    nssmdns4 = true; # Integrates .local resolution with your system's DNS
    openFirewall = true;
    wideArea = true;
    denyInterfaces = [
      "virbr0"
      "docker0"
    ];
    publish = {
      enable = true; # Allows services to be published
      addresses = true; # Publishes the machine's IP addresses
      workstation = true;
    };
  };
}
