{ config, pkgs, lib, ... }:

let name = "Tyler Vick";
    user = "tyler";
    email = "tyler@milo.cat"; in
{
  # Shared shell configuration
  zsh = {
    enable = true;
    autocd = false;
    oh-my-zsh = {
      enable = true;
      plugins = [
        "brew"
        "git"
        "macos"
        # "zsh-syntax-highlighting"
        # "zsh-autosuggestions"
      ];
    };
    plugins = [
      # {
      #   name = "powerlevel10k";
      #   src = pkgs.zsh-powerlevel10k;
      #   file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
      # }
      # {
      #   name = "powerlevel10k-config";
      #   src = lib.cleanSource ./config;
      #   file = "p10k.zsh";
      # }
    ];
    shellAliases = {
      sudo = "sudo ";
      o = "open";
      oo = "open .";
      g = "git";
      v = "vim";

      # Easier navigation: .., ..., ~ and -
      ".." = "cd ..";
      "cd.." = "cd ..";
      "..." = "cd ../..";
      "...." = "cd ../../..";
      "....." = "cd ../../../..";
      "~" = "cd ~";
      "-- -" = "cd -";

      # mv, rm, cp, gunzip
      mv = "mv -v";
      rm = "rm -i";
      cp = "cp -v";
      ungz = "gunzip -k";

      # IP addresses
      ip = "dig +short myip.opendns.com @resolver1.opendns.com";
      localip = "ipconfig getifaddr en1";
      myip = "ifconfig | grep 'inet ' | grep -v 127.0.0.1 | awk '{print \\$2}'";

      flushdns = "dscacheutil -flushcache";

      # Git aliases
      gss = "git status -s";
      gp = "git push origin HEAD";
      gpt = "git push origin HEAD && git push --tags";
      wip = "git commit -m'WIP' . && git push origin HEAD";
      gbr = "git branch --no-color | sed -e '/^[^*]/d' -e 's/* \\(.*\\)/\\1/'";
      gpo = "git push origin";
      grok = "ngrok start rem.jsbin-dev.com static.rem.jsbin-dev.com learn.rem.jsbin-dev.com";
      gl = "git log";
      glp5 = "git log -5 --pretty --oneline"; # view your last 5 latest commits each on their own line
      glt = "git log --all --graph --decorate --oneline --simplify-by-decoration"; # pretty branch status
      glsw = "git log -S"; # search the commit history for the word puppy and display matching commits (glsw [word])
      gs = "git status";
      gd = "git diff";
      gm = "git commit -m";
      gam = "git commit -am";
      gb = "git branch";
      gc = "git checkout";
      gcm = "git checkout master";
      gcmp = "git checkout master && git pull origin master";
      gra = "git remote add";
      grr = "git remote rm";
      gbt = "git_list_branches";
      gpu = "git pull origin HEAD --prune";
      gcl = "git clone";
      gta = "git tag -a -m";
      gf = "git reflog"; # allows you to see every step you have made with git allowing you to retract and reinstate your steps
      gap = "git add -p"; # step through each change, or hunk
      gsl = "git shortlog -sn"; # quickly get a list of contributors and see how many commits each person has
      gws = "git diff --shortstat \"@{0 day ago}\""; # how many lines of code you have written today
      gwts = "git ls-files | xargs wc -l"; # count number of lines of code in a git project
      ggmp = "git checkout -"; # jump back to to your last branch
      gst = "git stash"; # stash git changes and put them into your list
      gdtp = "git stash pop"; # bring back your changes, but it removes them from your stash
      gchp = "git cherry-pick"; # cherry pick the committed code in your own branch (gchp [hash])
      gcln = "git clean -xfd"; # remove untracked files

      b64 = "pbpaste | base64 --decode";

      # kubectl
      k = "kubectl";
      kp = "k get pods";

      # alias to kill process(es) binding to provided port. Usage: killport 8080
      killport = "(){kill $(lsof -t -i:$1);}";
    };

    initExtraFirst = ''
      if [[ -f /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh ]]; then
        . /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
        . /nix/var/nix/profiles/default/etc/profile.d/nix.sh
      fi

      # Define variables for directories
      export PATH=$HOME/.pnpm-packages/bin:$HOME/.pnpm-packages:$PATH
      export PATH=$HOME/.npm-packages/bin:$HOME/bin:$PATH
      export PATH=$HOME/.local/share/bin:$PATH

      # vscode
      export PATH="$PATH:/Applications/Visual Studio Code.app/Contents/Resources/app/bin"

      # Remove history data we don't want to see
      export HISTIGNORE="pwd:ls:cd"

      # Emacs is my editor
      export ALTERNATE_EDITOR=""
      #export EDITOR="emacsclient -t"
      #export VISUAL="emacsclient -c -a emacs"

      # nix shortcuts
      shell() {
          nix-shell '<nixpkgs>' -A "$1"
      }

      eval "$(zoxide init zsh)"

      # golang
      export GOPATH=$HOME/.go
    '';
  };

  git = {
    enable = true;
    ignores = [ "*.swp" ];
    userName = name;
    userEmail = email;
    lfs = {
      enable = true;
    };
    extraConfig = {
      init.defaultBranch = "main";
      core = { 
	    editor = "vim";
        autocrlf = "input";
      };
      pull.rebase = true;
      rebase.autoStash = true;
    };
  };

  vim = {
    enable = true;
    plugins = with pkgs.vimPlugins; [ vim-airline vim-airline-themes vim-startify vim-tmux-navigator ];
    settings = { ignorecase = true; };
    extraConfig = ''
      "" General
      set number
      set history=1000
      set nocompatible
      set modelines=0
      set encoding=utf-8
      set scrolloff=3
      set showmode
      set showcmd
      set hidden
      set wildmenu
      set wildmode=list:longest
      set cursorline
      set ttyfast
      set nowrap
      set ruler
      set backspace=indent,eol,start
      set laststatus=2
      set clipboard=autoselect

      " Dir stuff
      set nobackup
      set nowritebackup
      set noswapfile
      set backupdir=~/.config/vim/backups
      set directory=~/.config/vim/swap

      " Relative line numbers for easy movement
      set relativenumber
      set rnu

      "" Whitespace rules
      set tabstop=8
      set shiftwidth=2
      set softtabstop=2
      set expandtab

      "" Searching
      set incsearch
      set gdefault

      "" Statusbar
      set nocompatible " Disable vi-compatibility
      set laststatus=2 " Always show the statusline
      let g:airline_theme='bubblegum'
      let g:airline_powerline_fonts = 1

      "" Local keys and such
      let mapleader=","
      let maplocalleader=" "

      "" Change cursor on mode
      :autocmd InsertEnter * set cul
      :autocmd InsertLeave * set nocul

      "" File-type highlighting and configuration
      syntax on
      filetype on
      filetype plugin on
      filetype indent on

      "" Paste from clipboard
      nnoremap <Leader>, "+gP

      "" Copy from clipboard
      xnoremap <Leader>. "+y

      "" Move cursor by display lines when wrapping
      nnoremap j gj
      nnoremap k gk

      "" Map leader-q to quit out of window
      nnoremap <leader>q :q<cr>

      "" Move around split
      nnoremap <C-h> <C-w>h
      nnoremap <C-j> <C-w>j
      nnoremap <C-k> <C-w>k
      nnoremap <C-l> <C-w>l

      "" Easier to yank entire line
      nnoremap Y y$

      "" Move buffers
      nnoremap <tab> :bnext<cr>
      nnoremap <S-tab> :bprev<cr>

      "" Like a boss, sudo AFTER opening the file to write
      cmap w!! w !sudo tee % >/dev/null

      let g:startify_lists = [
        \ { 'type': 'dir',       'header': ['   Current Directory '. getcwd()] },
        \ { 'type': 'sessions',  'header': ['   Sessions']       },
        \ { 'type': 'bookmarks', 'header': ['   Bookmarks']      }
        \ ]

      let g:startify_bookmarks = [
        \ '~/.local/share/src',
        \ ]

      let g:airline_theme='bubblegum'
      let g:airline_powerline_fonts = 1
      '';
     };

  alacritty = {
    enable = true;
    settings = {
      cursor = {
        style = "Block";
      };

      keyboard.bindings = [
        { key = "Right"; mods = "Alt"; chars = "\x1BF"; }
        { key = "Left";  mods = "Alt"; chars = "\x1BB"; }
      ];

      selection.save_to_clipboard = true;

      window = {
        opacity = 1.0;
        padding = {
          x = 24;
          y = 24;
        };
      };

      font = {
        normal = {
          family = "MesloLGS NF";
          style = "Regular";
        };
        size = lib.mkMerge [
          (lib.mkIf pkgs.stdenv.hostPlatform.isLinux 10)
          (lib.mkIf pkgs.stdenv.hostPlatform.isDarwin 14)
        ];
      };

      # dynamic_padding = true;
      # decorations = "full";
      # title = "Terminal";
      # class = {
      #   instance = "Alacritty";
      #   general = "Alacritty";
      # };

      colors = {
        primary = {
          background = "0x1f2528";
          foreground = "0xc0c5ce";
        };

        normal = {
          black = "0x1f2528";
          red = "0xec5f67";
          green = "0x99c794";
          yellow = "0xfac863";
          blue = "0x6699cc";
          magenta = "0xc594c5";
          cyan = "0x5fb3b3";
          white = "0xc0c5ce";
        };

        bright = {
          black = "0x65737e";
          red = "0xec5f67";
          green = "0x99c794";
          yellow = "0xfac863";
          blue = "0x6699cc";
          magenta = "0xc594c5";
          cyan = "0x5fb3b3";
          white = "0xd8dee9";
        };
      };
    };
  };

  ssh = {
    enable = true;

    extraConfig = lib.mkMerge [
      ''
        Host *
          IdentityAgent "~/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock"
      ''
        #Host github.com
          #Hostname github.com
          #IdentitiesOnly yes
      #''
      #(lib.mkIf pkgs.stdenv.hostPlatform.isLinux
        #''
          #IdentityFile /home/${user}/.ssh/id_github
        #'')
      #(lib.mkIf pkgs.stdenv.hostPlatform.isDarwin
        #''
          #IdentityFile /Users/${user}/.ssh/id_github
        #'')
    ];
  };

  tmux = {
    enable = true;
    plugins = with pkgs.tmuxPlugins; [
      vim-tmux-navigator
      sensible
      yank
      prefix-highlight
      {
        plugin = power-theme;
        extraConfig = ''
           set -g @tmux_power_theme 'gold'
        '';
      }
      {
        plugin = resurrect; # Used by tmux-continuum

        # Use XDG data directory
        # https://github.com/tmux-plugins/tmux-resurrect/issues/348
        extraConfig = ''
          set -g @resurrect-dir '$HOME/.cache/tmux/resurrect'
          set -g @resurrect-capture-pane-contents 'on'
          set -g @resurrect-pane-contents-area 'visible'
        '';
      }
      {
        plugin = continuum;
        extraConfig = ''
          set -g @continuum-restore 'on'
          set -g @continuum-save-interval '5' # minutes
        '';
      }
    ];
    terminal = "screen-256color";
    prefix = "C-x";
    escapeTime = 10;
    historyLimit = 50000;
    extraConfig = ''
      # Remove Vim mode delays
      set -g focus-events on

      # Enable full mouse support
      set -g mouse on

      # -----------------------------------------------------------------------------
      # Key bindings
      # -----------------------------------------------------------------------------

      # Unbind default keys
      unbind C-b
      unbind '"'
      unbind %

      # Split panes, vertical or horizontal
      bind-key x split-window -v
      bind-key v split-window -h

      # Move around panes with vim-like bindings (h,j,k,l)
      bind-key -n M-k select-pane -U
      bind-key -n M-h select-pane -L
      bind-key -n M-j select-pane -D
      bind-key -n M-l select-pane -R

      # Smart pane switching with awareness of Vim splits.
      # This is copy paste from https://github.com/christoomey/vim-tmux-navigator
      is_vim="ps -o state= -o comm= -t '#{pane_tty}' \
        | grep -iqE '^[^TXZ ]+ +(\\S+\\/)?g?(view|n?vim?x?)(diff)?$'"
      bind-key -n 'C-h' if-shell "$is_vim" 'send-keys C-h'  'select-pane -L'
      bind-key -n 'C-j' if-shell "$is_vim" 'send-keys C-j'  'select-pane -D'
      bind-key -n 'C-k' if-shell "$is_vim" 'send-keys C-k'  'select-pane -U'
      bind-key -n 'C-l' if-shell "$is_vim" 'send-keys C-l'  'select-pane -R'
      tmux_version='$(tmux -V | sed -En "s/^tmux ([0-9]+(.[0-9]+)?).*/\1/p")'
      if-shell -b '[ "$(echo "$tmux_version < 3.0" | bc)" = 1 ]' \
        "bind-key -n 'C-\\' if-shell \"$is_vim\" 'send-keys C-\\'  'select-pane -l'"
      if-shell -b '[ "$(echo "$tmux_version >= 3.0" | bc)" = 1 ]' \
        "bind-key -n 'C-\\' if-shell \"$is_vim\" 'send-keys C-\\\\'  'select-pane -l'"

      bind-key -T copy-mode-vi 'C-h' select-pane -L
      bind-key -T copy-mode-vi 'C-j' select-pane -D
      bind-key -T copy-mode-vi 'C-k' select-pane -U
      bind-key -T copy-mode-vi 'C-l' select-pane -R
      bind-key -T copy-mode-vi 'C-\' select-pane -l
      '';
    };
}
