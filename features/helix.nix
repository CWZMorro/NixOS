{ pkgs, ... }:
{
  programs.helix = {
    enable = true;
    defaultEditor = true;

    settings = {

      theme = "catppuccin_mocha";

      editor = {
        default-yank-register = "+";

        line-number = "relative";
        color-modes = true;
        bufferline = "multiple";
        cursor-shape = {
          insert = "bar";
          normal = "block";
          select = "underline";
        };

        # UI
        indent-guides.render = true;
        lsp.display-messages = true;
        lsp.display-inlay-hints = true;

        # Show hidden files
        file-picker.hidden = true;

        statusline = {
          left = [
            "mode"
            "spinner"
            "file-name"
            "file-modification-indicator"
          ];
          center = [ "diagnostics" ];
          right = [
            "selections"
            "position"
            "file-encoding"
            "file-type"
            "version-control"
          ];
          mode.normal = "NORMAL";
          mode.insert = "INSERT";
          mode.select = "SELECT";
        };
      };

      keys.normal = {
        w = [
          "move_next_word_start"
          "collapse_selection"
        ];
        e = [
          "move_next_word_end"
          "collapse_selection"
        ];
        b = [
          "move_prev_word_start"
          "collapse_selection"
        ];

        "0" = "goto_line_start";
        "^" = "goto_first_nonwhitespace";
        "G" = "goto_file_end";

        space.space = "file_picker";
        space."/" = "global_search";
        space.e = "file_explorer";

        space.w = ":w";
        space.q = ":q";

        space.b = {
          d = ":buffer-close";
          n = ":buffer-next";
          p = ":buffer-previous";
        };

        space.c = {
          a = "code_action";
          r = "rename_symbol";
          f = ":format";
        };
        "C-h" = "jump_view_left";
        "C-j" = "jump_view_down";
        "C-k" = "jump_view_up";
        "C-l" = "jump_view_right";

        esc = [
          "collapse_selection"
          "keep_primary_selection"
        ];
      };

      keys.insert = {
        # Standard fast exit from insert mode
        "C-c" = "normal_mode";
      };
    };

    # =========================================
    # LANGUAGE SERVERS & FORMATTERS
    # =========================================
    languages = {
      language-server = {
        basedpyright = {
          command = "basedpyright-langserver";
          args = [ "--stdio" ];
        };
        ruff = {
          command = "ruff";
          args = [ "server" ];
        };
        nixd = {
          command = "nixd";
        };
      };

      language = [
        {
          name = "nix";
          auto-format = true;
          language-servers = [ "nixd" ];
          formatter.command = "${pkgs.nixfmt-rfc-style}/bin/nixfmt";
        }
        {
          name = "python";
          auto-format = true;
          language-servers = [
            "basedpyright"
            "ruff"
          ];
          formatter = {
            command = "${pkgs.ruff}/bin/ruff";
            args = [
              "format"
              "-"
            ];
          };
        }
        {
          name = "rust";
          auto-format = true;
          language-servers = [ "rust-analyzer" ];
          formatter.command = "${pkgs.rustfmt}/bin/rustfmt";
        }
        {
          name = "typescript";
          auto-format = true;
          language-servers = [ "typescript-language-server" ];
          formatter = {
            command = "${pkgs.nodePackages.prettier}/bin/prettier";
            args = [
              "--parser"
              "typescript"
            ];
          };
        }
        {
          name = "tsx";
          auto-format = true;
          language-servers = [
            "typescript-language-server"
            "tailwindcss-ls"
          ];
          formatter = {
            command = "${pkgs.nodePackages.prettier}/bin/prettier";
            args = [
              "--parser"
              "typescript"
            ];
          };
        }
        {
          name = "json";
          auto-format = true;
          formatter = {
            command = "${pkgs.nodePackages.prettier}/bin/prettier";
            args = [
              "--parser"
              "json"
            ];
          };
        }
        {
          name = "markdown";
          auto-format = true;
          language-servers = [ "marksman" ];
          formatter = {
            command = "${pkgs.nodePackages.prettier}/bin/prettier";
            args = [
              "--parser"
              "markdown"
            ];
          };
        }
        {
          name = "lua";
          auto-format = true;
          language-servers = [ "lua-language-server" ];
          formatter = {
            command = "${pkgs.stylua}/bin/stylua";
            args = [ "-" ];
          };
        }
        {
          name = "java";
          language-servers = [ "jdtls" ];
        }
      ];
    };
  };
}
