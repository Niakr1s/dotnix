{
  pkgs,
  username,
  ...
}: {
  home-manager.users.${username} = {
    home.packages = with pkgs; [
      gnomeExtensions.todotxt
    ];
    dconf.settings = {
      "org/gnome/shell" = {
        enabled-extensions = [
          pkgs.gnomeExtensions.todotxt.extensionUuid
        ];
      };
      "org/gnome/shell/extensions/TodoTxt" = {
        add-creation-date = true;
        color-done-tasks = false;
        confirm-delete = true;
        custom-done-tasks-color = "rgb(94,92,100)";
        debug-level = 250;
        display-format-string = "{undone}";
        done-task-bold = false;
        done-task-strikethrough = true;
        donetxt-location = "/home/${username}/.local/share/todo.txt/done.txt";
        enable-due-date-extension = true;
        enable-hidden-extension = false;
        group-by = 0;
        group-ungrouped = false;
        hide-pattern = "{unarchived}";
        keep-open-after-new = true;
        long-tasks-ellipsize-mode = 2;
        long-tasks-max-width = 300;
        order-by-priority = true;
        priorities-markup = "{'A': (true, 'rgb(246,97,81)', true, false), 'B': (true, 'rgb(249,240,107)', true, false), 'C': (true, 'rgb(87,227,137)', true, false)}";
        show-contexts-label = true;
        show-delete-button = true;
        show-done = true;
        show-done-or-archive-button = true;
        show-new-task-entry = true;
        show-number-of-group-elements = true;
        show-open-preferences = true;
        show-projects-label = true;
        show-status-icon = true;
        style-priorities = true;
        todotxt-location = "/home/${username}/.local/share/todo.txt/todo.txt";
        truncate-long-tasks = true;
        url-color = 1;
      };
    };
  };
}
