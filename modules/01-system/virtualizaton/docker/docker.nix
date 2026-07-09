{config, ...}: {
  virtualisation.docker = {
    enable = true;
    # Use the rootless mode - run Docker daemon as non-root user
    rootless = {
      enable = true;
      setSocketVariable = true;
      # Customize Docker daemon settings using the daemon.settings option
      daemon.settings = {
        # You may also need to adjust your docker compose file to use cdi instead of the nvidia driver.
        # services:
        #   ollama:
        #     image: ollama/ollama
        #     volumes:
        #       - ollama:/root/.ollama
        #     ports:
        #       - 11434:11434
        #     deploy:
        #       resources:
        #         reservations:
        #           devices:
        #             # Go from this:
        #             # - driver: nvidia
        #             #   count: all
        #             #   capabilities: [gpu]
        #             # To this:
        #             - driver: cdi
        #               capabilities: [gpu]
        #               device_ids:
        #                 - nvidia.com/gpu=all
        # volumes:
        #   ollama: {}
        features.cdi = true; # for gpu accelleration

        dns = ["1.1.1.1" "8.8.8.8"];
        log-driver = "journald";
        registry-mirrors = ["https://mirror.gcr.io"];
        storage-driver = "overlay2";
      };
    };
  };
}
