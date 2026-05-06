{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    (handbrake.overrideAttrs (previous: {
      nativeBuildInputs = (previous.nativeBuildInputs or []) ++ [pkgs.autoAddDriverRunpath];
    }))
  ];
}
