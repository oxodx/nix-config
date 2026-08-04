{
  # Agent (AI) panel settings
  # https://zed.dev/docs/ai/agent-settings
  agent = {
    sidebar_side = "right";
    default_profile = "ask";
    favorite_models = [
      {
        provider = "opencode";
        model = "free/big-pickle";
        enable_thinking = false;
      }
      {
        provider = "openrouter";
        model = "openai/gpt-oss-20b:free";
        enable_thinking = false;
      }
    ];
    dock = "right";
    inline_assistant_model = {
      provider = "opencode";
      model = "free/big-pickle";
    };
    default_model = {
      provider = "opencode";
      model = "free/big-pickle";
    };
    # Notify when the agent finishes work while Zed is in background
    # https://zed.dev/docs/ai/agent-settings#notify-when-agent-waiting
    # Options: "primary_screen", "all_screens", "never"
    notify_when_agent_waiting = "primary_screen";
    # Play a sound when the agent is done
    # https://zed.dev/docs/ai/agent-settings#play-sound-when-agent-done
    # Options: "never", "when_hidden", "always"
    play_sound_when_agent_done = "never";
    # Show inline diff review for agent edits in the active buffer
    # https://zed.dev/docs/ai/agent-settings#single-file-review
    single_file_review = true;
    # Automatically follow the agent as it reads/edits files
    agent_follow = true;
    # Model-specific generation parameters
    # https://zed.dev/docs/ai/agent-settings#model-temperature
    model_parameters = [
      {
        provider = "opencode";
        # Lower temperature for code editing (more deterministic)
        temperature = 0.3;
      }
    ];
    # Show multiple inline assist alternatives
    # https://zed.dev/docs/ai/agent-settings#inline-alternatives
    inline_alternatives = [
      {
        provider = "opencode";
        model = "free/minimax-m2.5-free";
      }
      {
        provider = "opencode";
        model = "free/big-pickle";
      }
    ];
    commit_message_model = {
      provider = "openrouter";
      model = "openai/gpt-oss-20b:free";
    };
    # AI Support in Git
    # https://zed.dev/docs/git#ai-support-in-git
    commit_message_instructions = "Use the Conventional Commits format: <type>(<scope>): <description>.";
    # Agent profiles (like sidekick.nvim profiles)
    # https://zed.dev/docs/ai/agent-settings#agent-profiles
    profiles = {
      write = {
        name = "Write Code";
        tools = {
          edit_file = true;
          create_file = true;
          delete_file = true;
          rename_file = true;
          find_file = true;
          terminal = true;
          search = true;
          fetch = true;
          run_command = true;
          copy_path = true;
          move_path = true;
          open_file = true;
          go_to_file = true;
          set_context = true;
          set_files = true;
          spawn_agent = false;
          create_task = false;
        };
        enable_all_context_servers = true;
      };
      review = {
        name = "Code Review";
        tools = {
          edit_file = false;
          create_file = false;
          delete_file = false;
          rename_file = false;
          find_file = true;
          terminal = false;
          search = true;
          fetch = true;
          run_command = false;
          copy_path = true;
          move_path = false;
          open_file = true;
          go_to_file = true;
          set_context = true;
          set_files = true;
          spawn_agent = false;
          create_task = false;
        };
        enable_all_context_servers = true;
        default_model = {
          provider = "opencode";
          model = "free/minimax-m2.5-free";
        };
      };
      debug = {
        name = "Debug";
        tools = {
          edit_file = true;
          create_file = false;
          delete_file = false;
          rename_file = false;
          find_file = true;
          terminal = true;
          search = true;
          fetch = true;
          run_command = true;
          copy_path = true;
          move_path = false;
          open_file = true;
          go_to_file = true;
          set_context = true;
          set_files = true;
          spawn_agent = true;
          create_task = false;
        };
        enable_all_context_servers = false;
        default_model = {
          provider = "opencode";
          model = "free/minimax-m2.5-free";
        };
      };
    };
    # Tool permission defaults
    # https://zed.dev/docs/ai/agent-settings#tool-permissions
    tool_permissions = {
      default = "confirm";
      tools = {
        terminal = {
          always_allow = [
            {pattern = "^(cargo|npm|bun|pnpm|yarn|deno)\\s+(build|test|check|run|format|lint|fix)";}
            {pattern = "^(git\\s+(add|commit|diff|log|status|push|pull|branch\\s+-[Dd]))";}
            {pattern = "^(ls|cat|head|tail|wc|echo|pwd|which|type|file)";}
          ];
          always_deny = [
            {pattern = "^(sudo|su|doas)\\s";}
            {pattern = "^rm\\s+-[rf]\\s+/";}
          ];
        };
        fetch = {
          always_allow = [
            {pattern = "^https://(api\\.)?github\\.com";}
            {pattern = "^https://raw\\.githubusercontent\\.com";}
          ];
        };
      };
    };
    # Persistent sandbox permission grants
    # https://zed.dev/docs/ai/agent-settings#sandbox-permissions
    sandbox_permissions.allow_network = true;
  };

  # Assistant settings (for local AI with Ollama)
  # https://zed.dev/docs/language-model-integration
  # Uncomment below to use local AI with Ollama:
  # assistant = {
  #   default_model = {
  #     provider = "ollama";
  #     model = "llama3.1:latest";
  #   };
  #   version = "2";
  #   provider = null;
  # };

  # Language models configuration
  # https://zed.dev/docs/language-model-integration
  language_models = {
    opencode = {
      show_go_models = false;
      show_zen_models = false;
    };
    ollama.api_url = "http://localhost:11434";
    openai_compatible = {};
  };
}
