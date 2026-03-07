{
  config,
  lib,
  pkgs,
  inputs,
  nixpkgs-unstable,
  stateVersion,
  hostname,
  username,
  ...
}: let
in {
  # aichat
  programs.aichat = {
    enable = true;

    settings = {
      model = "ollama:gemma3:12b"; # Default model config
      clients = [
        {
          type = "openai-compatible";
          name = "ollama";
          api_base = "http://localhost:11434/v1";
          models = [
            {
              # should correspond to ollama.nix
              name = "gemma3:12b";

              # ollama show _model_, under Capabilities section
              supports_completion = true;
              supports_function_calling = false;
              supports_vision = true;
              supports_reasoning = false;
            }
          ];
        }
      ];
    };
  };
}
