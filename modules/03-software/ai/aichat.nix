{username, ...}: {
  home-manager.users.${username} = {
    # aichat
    programs.aichat = {
      enable = true;

      # Example config
      # model: ollama:gemma4:e4b
      # clients:
      # - type: openai-compatible
      #   name: ollama
      #   api_base: http://localhost:11434/v1
      #   models:
      #   - name: gemma4:e4b
      #   - name: qwen3-embedding:8b
      #     type: embedding
      #     default_chunk_size: 1000
      #     max_batch_size: 100
      #   - name: qwen3.5:9b

      settings = {
        highlight = true;

        model = "ollama:gemma4:e4b"; # Default model config
        clients = [
          {
            type = "openai-compatible";
            name = "ollama";
            api_base = "http://localhost:11434/v1";
            models = [
              {
                # should correspond to ollama.nix
                name = "gemma4:e4b";
                supports_completion = true;
                supports_vision = true;
                supports_audio = true;
                supports_tools = true;
                supports_thinking = true;
                supports_function_calling = true;
                use_tools = true;
              }
              {
                # should correspond to ollama.nix
                name = "qwen3.5:9b";
                supports_completion = true;
                supports_vision = true;
                supports_tools = true;
                supports_thinking = true;
                supports_function_calling = true;
                use_tools = true;
              }
              {
                # should correspond to ollama.nix
                name = "qwen3-embedding:8b";
                type = "embedding";
              }
            ];
          }
        ];
        rag_embedding_model = "ollama:qwen3-embedding:8b";
        rag_top_k = 5; # Specifies the number of documents to retrieve for answering queries
      };
    };
  };
}
