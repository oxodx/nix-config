{
  plugins.neo-tree = {
    enable = true;
    settings = {
      enable_diagnostics = true;
      enable_git_status = true;
      enable_modified_markers = true;
      enable_refresh_on_write = true;
      close_if_last_window = true;
      popup_border_style = "rounded";
      buffers = {
        bind_to_cwd = false;
        follow_current_file.enabled = true;
      };
      window = {
        width = 40;
        height = 15;
        auto_expand_width = false;
        mappings = {
          "<space>" = "none";
        };
      };
    };
  };
}
