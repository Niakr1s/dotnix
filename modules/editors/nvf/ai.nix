{
  inputs,
  username,
  ...
}: {
  home-manager.users.${username} = {
    programs.nvf = {
      settings = {
        vim = {
          assistant = {
            avante-nvim = {
              enable = true;
              setupOpts = {
                provider = "ollama";
                auto_suggestions_provider = "ollama";
                behaviour = {
                  auto_suggestions = false;
                };
                providers = {
                  ollama = {
                    endpoint = "http://127.0.0.1:11434";
                    timeout = 30000; # Timeout in milliseconds
                    model = "qwen2.5-coder:7b";
                    extra_request_body = {
                      options = {
                        temperature = 0.75;
                        num_ctx = 20480;
                        keep_alive = "5m";
                      };
                    };
                  };
                };
              };
            };
          };
        };
      };
    };
  };
}
