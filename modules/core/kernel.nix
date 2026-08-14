{
  config,
  pkgs,
  ...
}:
let
  cpu = config.modules.core.cpu;
in
{
  boot = {
    kernelPackages = (pkgs.linuxPackages);
    kernelParams =
      if cpu.amd then
        [ "amd_pstate=active" ]
      else if cpu.intel then
        [ "intel_pstate=active" ]
      else
        [ ];
  };
  assertions = [
    {
      assertion = cpu.amd || cpu.intel;
      message = "core.cpu.amd or core.cpu.intel must be set on each host";
    }
  ];
}
