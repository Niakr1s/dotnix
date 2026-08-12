{
  config,
  pkgs,
  ...
}:
let
  headless = config.core.headless;
  usesAuto-cpufreq = config.core.isLaptop.usesAuto-cpufreq;
  usesPPD = config.core.isLaptop.usesPPD;
  isLaptop = config.core.isLaptop.enable;
in
{
  services = {
    openssh = {
      enable = true;
      settings = {
        PasswordAuthentication = true;
        PermitRootLogin = "no";
      };
    };
  };
}
