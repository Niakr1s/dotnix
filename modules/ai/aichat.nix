{username, ...}: {
  home-manager.users.${username} = {
    # aichat
    programs.aichat = {
      enable = true;

      settings = {
        highlight = true;

        model = "qwen2.5-coder:7b"; # Default model config
        clients = [
          {
            type = "openai-compatible";
            name = "ollama";
            api_base = "http://localhost:11434/v1";
            models = [
              {
                # should correspond to ollama.nix
                name = "qwen2.5-coder:7b";

                # ollama show _model_, under Capabilities section
                supports_completion = true;
                supports_tools = true;
                supports_insert = true;
              }
              {
                # should correspond to ollama.nix
                name = "qwen2.5-coder:14b";

                # ollama show _model_, under Capabilities section
                supports_completion = true;
                supports_tools = true;
                supports_insert = true;
              }
            ];
          }
        ];
      };
    };
  };
}
