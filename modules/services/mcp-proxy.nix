{ pkgs, ... }:

{
  virtualisation.oci-containers.containers."mcp-proxy" = {
    image = "ghcr.io/sparfenyuk/mcp-proxy:latest";
    autoStart = true;

    extraOptions = [ "--network=host" ];

    # Replicates the ENV instructions
    environment = {
      PATH = "/usr/local/bin:/usr/bin:/bin:/app/.venv/bin";
      UV_PYTHON_PREFERENCE = "only-system";
      PIP_ROOT_USER_ACTION = "ignore";
      # Force the application framework (Uvicorn) to listen on all interfaces
      HOST = "0.0.0.0";
      PORT = "8096";
    };

    # Replicates the RUN/ENTRYPOINT steps safely via standard container overrides
    # Runs the pip installation and then chains execution to catatonit
    entrypoint = "sh";
    cmd = [
      "-c"
      "python3 -m ensurepip && pip install --no-cache-dir uv && exec catatonit -- mcp-proxy --pass-environment --port=8096 --sse-host 0.0.0.0 uvx mcp-server-fetch"
    ];
  };
}

