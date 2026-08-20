{ pkgs, lib, ... }:

let
  # Define the MCP proxy configuration as a Nix attribute set
  mcpConfig = {
    mcpServers = {
      ddg-search = {
        command = "${pkgs.uv}/bin/uvx";
        args = ["duckduckgo-mcp-server"];
      };
      time = {
        command = "${pkgs.mcp-server-time}/bin/mcp-server-time";
      };
      fetch = {
        command = "${pkgs.mcp-server-fetch}/bin/mcp-server-fetch";
        args = [ "--ignore-robots-txt" ];
      };
      nixos = {
        command = "${pkgs.mcp-nixos}/bin/mcp-nixos";
      };
      context7 = {
        command = "${pkgs.context7-mcp}/bin/context7-mcp";
      };
      playwright = {
        command = "${pkgs.playwright-mcp}/bin/playwright-mcp";
        args = [ "--headless" "--user-data-dir" "/var/lib/mcp-proxy/.cache/playwright" ];
      };
    };
  };

  # Convert the Nix attribute set into a JSON file for the service
  configFile = pkgs.writeText "mcp-proxy-config.json" (builtins.toJSON mcpConfig);

  servicename = "mcp-proxy";
  mcp-proxy-home = "/var/lib/${servicename}";
in
{
  # Ensure the required packages are installed
  environment.systemPackages = with pkgs; [
    mcp-proxy
    uv

    mcp-nixos
    mcp-server-fetch
    mcp-server-time
    context7-mcp
    playwright-mcp
  ];

  users.users."${servicename}" = {
    isSystemUser = true;
    group = "${servicename}";
    home = "${mcp-proxy-home}";
    createHome = true;
  };
  users.groups.mcp-proxy = {};

  # Systemd service definition
  systemd.services.mcp-proxy = {
    description = "MCP Proxy Service";
    after = [ "network.target" ];
    wantedBy = [ "multi-user.target" ];

    environment = {
      HOME = "${mcp-proxy-home}";
      UV_CACHE_DIR = "${mcp-proxy-home}/.cache/uv";
      UV_DATA_DIR = "${mcp-proxy-home}/.local/share/uv";
      NPM_CONFIG_CACHE = "${mcp-proxy-home}/.npm";
    };

    serviceConfig = {
      ExecStart = "${pkgs.mcp-proxy}/bin/mcp-proxy --port=8096 --named-server-config ${configFile}";
      Restart = "always";
      RestartSec = "5s";

      User = "${servicename}";
      Group = "${servicename}";
      WorkingDirectory = "${mcp-proxy-home}";
      StateDirectory = "${servicename}";

      ProtectSystem = "strict";
      PrivateTmp = true;
      ProtectHome = true;
      NoNewPrivileges = false;
    };
  };
}

