{
  pkgs,
  username,
  ...
}: {
  boot.kernelModules = ["kvm-amd" "kvm-intel"];

  virtualisation.libvirtd = {
    enable = true;
    qemu.vhostUserPackages = with pkgs; [
      virtiofsd # To be able to share a folder with a guest, you will need 'virtiofsd'.
    ];
  };

  programs.virt-manager.enable = true;
  users.users.${username}.extraGroups = ["libvirtd"];

  # Networking
  #
  # To use the default libvirt network, you will need to install the dnsmasq package.\
  # This is required for DNS and DCHP functionality within the network

  # The default network starts off inactive, you must enable it before it is accessible. This can be done by running the following command:
  # virsh net-start default
  # And if you would like to enable it automatically at boot:
  # virsh net-autostart default

  environment.systemPackages = with pkgs; [
    dnsmasq
  ];

  # By default, this will enable a virtual network bridge under the name virbr0.
  # You may need to allow it through your firewall filter like so:
  networking.firewall.trustedInterfaces = ["virbr0"];
}
