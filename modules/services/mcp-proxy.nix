{ pkgs, config, ... }:

let
  # Define the MCP proxy configuration as a Nix attribute set
  mcpConfig = {
    mcpServers = {
      fetch = {
        command = "${pkgs.mcp-server-fetch}/bin/mcp-server-fetch";
        args = [ "--ignore-robots-txt" ];
      };
      ddg-search = {
        command = "${pkgs.uv}/bin/uvx";
        args = ["duckduckgo-mcp-server"];
      };
    };
  };

  # Convert the Nix attribute set into a JSON file for the service
  configFile = pkgs.writeText "mcp-proxy-config.json" (builtins.toJSON mcpConfig);
in
{
  # Ensure the required packages are installed
  environment.systemPackages = with pkgs; [
    mcp-proxy
    mcp-server-fetch
    uv
  ];

  users.users.mcp-proxy = {
    isSystemUser = true;
    group = "mcp-proxy";
    home = "/var/lib/mcp-proxy";
    createHome = true;
  };
  users.groups.mcp-proxy = {};

  # Systemd service definition
  systemd.services.mcp-proxy = {
    description = "MCP Proxy Service";
    after = [ "network.target" ];
    wantedBy = [ "multi-user.target" ];

    environment = {
      HOME = "/var/lib/mcp-proxy";
      UV_CACHE_DIR = "/var/lib/mcp-proxy/.cache/uv";
      UV_DATA_DIR = "/var/lib/mcp-proxy/.local/share/uv";
    };

    serviceConfig = {
      # Runs the proxy, pointing it to the generated JSON configuration file
      ExecStart = "${pkgs.mcp-proxy}/bin/mcp-proxy --port=8096 --named-server-config ${configFile}";
      Restart = "always";
      RestartSec = "5s";

      User = "mcp-proxy";
      Group = "mcp-proxy";
      WorkingDirectory = "/var/lib/mcp-proxy";
      StateDirectory = "mcp-proxy";

      ProtectSystem = "strict";
      ProtectHome = true;
      NoNewPrivileges = false;
    };
  };
}

