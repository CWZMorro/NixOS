{ ... }:

{
  # Shell config
  programs.fish = {
    enable = true;
    shellAliases = {
      # eza
      ls = "eza --color=always --icons=always";
      ll = "eza -lg --color=always --icons=always";
      lt = "eza --tree --color=always --icons=always";

      # git
      lg = "lazygit";

      # NixOS
      rebuild = "sudo nixos-rebuild switch --flake ~/nixos-config#CielNixAzure";
      conf = "nvim ~/nixos-config/hosts/local/configuration.nix";
      home = "nvim ~/nixos-config/home/cielnixazure/home.nix";

      # fun
      bonsai = "cbonsai -li";
    };
    functions = {
      # ssh hosts from ~/.ssh/config
      cielmacazure = "ssh mac";
      heylaubuntuazure = "ssh ubuntu";

      # run omp in ~/firstmate
      fm = ''
        pushd ~/firstmate; or return
        omp $argv
        popd
      '';

      # Prompt: distro icon, current dir, jj bookmark (or git branch), ❯ colored by last exit status
      fish_prompt = ''
        set -l last_status $status

        set -l os_icon (prompt_os_icon)
        if test -n "$os_icon"
            set_color cyan
            printf '%s ' $os_icon
            set_color normal
        end

        set_color blue
        if test "$PWD" = "$HOME"
            printf ' ~ '
        else
            printf ' %s ' (path basename -- $PWD)
        end
        set_color normal

        # jj > git
        set -l vcs (prompt_jj_info)
        if test -z "$vcs"
            set vcs (prompt_git_info)
        end
        if test -n "$vcs"
            set_color yellow
            printf ' %s ' $vcs
            set_color normal
        end

        if test $last_status -eq 0
            set_color green
        else
            set_color red
        end
        printf '❯ '
        set_color normal
      '';
      prompt_os_icon = {
        description = "Print a nerd-font distro icon based on /etc/os-release";
        body = ''
          test -r /etc/os-release; or return 1
          # read + parse with fish builtins (redirection + string match)
          set -l os_id (string match -rg '^ID=(.*)$' < /etc/os-release 2>/dev/null)
          test -n "$os_id"; or return 1
          set os_id (string trim -c '"' -- $os_id[1])
          switch $os_id
              case arch
                  printf ''
              case nixos
                  printf ''
              case '*'
                  return 1
          end
        '';
      };
      prompt_git_info = {
        description = "Print git branch if inside a git repo";
        body = ''
          command -sq git; or return 1
          prompt_repo_root .git >/dev/null; or return 1

          set -l ref (command git rev-parse --abbrev-ref HEAD 2>/dev/null)
          test -n "$ref"; or return 1
          if test "$ref" = HEAD
              set ref (command git rev-parse --short HEAD 2>/dev/null)
              test -n "$ref"; or return 1
          end
          printf '%s' $ref
        '';
      };
      prompt_jj_info = {
        description = "Print jj bookmark";
        body = ''
          command -sq jj; or return 1
          prompt_repo_root .jj >/dev/null; or return 1

          set -l info (jj log --no-graph --ignore-working-copy --color=never --revisions @ \
                  --template 'separate(" ", coalesce(bookmarks, change_id.shortest(8)), if(conflict, "!conflict"))' \
                  2>/dev/null)
          or return 1
          test -n "$info"; or return 1
          printf '%s' $info
        '';
      };
      prompt_repo_root = {
        description = "Walk up from PWD looking for a file/dir named \\$argv[1] (e.g. .git or .jj), print the dir if found.";
        body = ''
          set -l dir $PWD
          while true
              if test -e "$dir/$argv[1]"
                  printf '%s' $dir
                  return 0
              end
              if test "$dir" = /
                  return 1
              end
              set dir (path dirname -- $dir)
          end
        '';
      };
    };
    interactiveShellInit = ''
      # Fastfetch
      if set -q HERDR_PANE_ID # inside herdr
          fastfetch -c ~/.config/fastfetch/minimal.jsonc --logo-type none
      else
          fastfetch -c ~/.config/fastfetch/minimal.jsonc
      end

      # zoxide
      zoxide init fish --cmd cd | source

      # fuzzy finder
      fzf --fish | source
    '';
  };
}
