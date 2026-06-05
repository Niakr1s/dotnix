local wezterm = require("wezterm")
local act = wezterm.action
local config = wezterm.config_builder()

config.font_size = 10
config.color_scheme = 'GitHub Dark'
config.window_background_opacity = 0.99

-- Plugins
local sessions = wezterm.plugin.require(
  "https://github.com/abidibo/wezterm-sessions"
)

config.leader = { key = 'q', mods = 'CTRL', timeout_milliseconds = 1000 }
config.keys = {
  -- swap panes
  {
    mods = 'LEADER',
    key = '0',
    action = wezterm.action.PaneSelect {
      mode = 'SwapWithActive',
    },
  },
  -- splitting
  {
    mods   = "LEADER",
    key    = "=",
    action = wezterm.action.SplitVertical { domain = 'CurrentPaneDomain' }
  },
  {
    mods   = "LEADER",
    key    = "-",
    action = wezterm.action.SplitHorizontal { domain = 'CurrentPaneDomain' }
  },
  -- activate copy mode or vim mode
  {
    key = 'Enter',
    mods = 'LEADER',
    action = wezterm.action.ActivateCopyMode
  },
  -- toglgle maximized state
  {
    mods = 'LEADER',
    key = 'm',
    action = wezterm.action.TogglePaneZoomState
  },
  {
    key = "S",
    mods = "LEADER",
    action = wezterm.action.ShowLauncher
  },
  {
    key = "s",
    mods = "LEADER",
    action = wezterm.action.ShowLauncherArgs { flags = "FUZZY|WORKSPACES" }
  },
    -- Rename current workspace
  {
      key = '$',
      mods = 'CTRL|SHIFT',
      action = act.PromptInputLine {
          description = 'Enter new workspace name',
          action = wezterm.action_callback(
              function(window, pane, line)
                  if line then
                      wezterm.mux.rename_workspace(wezterm.mux.get_active_workspace(), line)
                  end
              end
          ),
      },
  },
  -- Prompt for a name to use for a new workspace and switch to it.
  {
      key = 'w',
      mods = 'CTRL|SHIFT',
      action = act.PromptInputLine {
          description = wezterm.format {
              { Attribute = { Intensity = 'Bold' } },
              { Foreground = { AnsiColor = 'Fuchsia' } },
              { Text = 'Enter name for new workspace' },
          },
          action = wezterm.action_callback(function(window, pane, line)
              -- line will be `nil` if they hit escape without entering anything
              -- An empty string if they just hit enter
              -- Or the actual line of text they wrote
              if line then
                  window:perform_action(
                      act.SwitchToWorkspace {
                          name = line,
                      },
                      pane
                  )
              end
          end),
      },
  },
  -- nvim smart-splits integration
  table.unpack(require("smart-splits").keys),
}

sessions.apply_to_config(config, {})
return config
