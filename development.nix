{ pkgs, ... }:
let
  nixvim = import (
    builtins.fetchGit {
      url = "https://github.com/nix-community/nixvim";
      ref = "nixos-24.11";
    }
  );
in
{
  #################### Git configuration ####################
  programs.git = {
    enable = true;
    lfs.enable = true;
    config = {
      user = {
        email = "vili.m.sinerva@gmail.com";
        name = "Vili Sinervä";
        signingkey = "DF8FEAF54EFAC996!";
      };
      merge = {
        ff = "true";
      };
      pull = {
        ff = "only";
      };
      commit = {
        verbose = "true";
      };
      commit.gpgsign = "true";
    };
  };

  #################### Packages ####################
  environment.systemPackages = with pkgs; [
    nixfmt-rfc-style
    nixd
  ];

  fonts.packages = with pkgs; [
    nerdfonts
  ];

  #################### Neovim configuration ####################
  imports = [ nixvim.nixosModules.nixvim ];

  programs.nixvim = {
    enable = true;
    defaultEditor = true;
    vimAlias = true;
    colorschemes.vscode.enable = true;

    globals.mapleader = " ";

    opts = {
      colorcolumn = "100";
      cursorline = true;
      number = true;
      showcmd = true;
      signcolumn = "yes";

      scrolloff = 16;
      shiftwidth = 3;
      tabstop = 3;
    };

    keymaps = [
      {
        key = "T";
        action = "<cmd>Neotree<cr>";
        options = {
          silent = true;
          desc = "Open Neotree";
        };
      }
    ];

    # TODO Check desireable keybinds and commands for LSP
    plugins = {
      fugitive.enable = true;
      gitsigns = {
        enable = true;
        settings = {
          current_line_blame_opts.delay = 100;
          numhl = true;
        };
      };
      lualine.enable = true;
      markdown-preview.enable = true;
      neo-tree = {
        enable = true;
        buffers.followCurrentFile = {
          enabled = true;
          leaveDirsOpen = true;
        };
      };
      nix.enable = true;
      rainbow-delimiters.enable = true;
      sleuth.enable = true;
      tmux-navigator = {
        enable = true;
        settings.no_mappings = 1;
        keymaps = [
          {
            key = "<C-h>";
            action = "left";
            options.desc = "Tmux Left";
          }
          {
            key = "<C-j>";
            action = "down";
            options.desc = "Tmux Down";
          }
          {
            key = "<C-k>";
            action = "up";
            options.desc = "Tmux Up";
          }
          {
            key = "<C-l>";
            action = "right";
            options.desc = "Tmux Right";
          }
        ];
      };
      treesitter = {
        enable = true;
        folding = true;
        settings.indent.enable = true;
        nixGrammars = true;
      };
      web-devicons.enable = true;
      which-key = {
        enable = true;
        settings.delay.__raw = ''
          function(ctx)
            return ctx.plugin and 0 or 500
          end
        '';
      };

      cmp = {
        enable = true;
        settings = {
          sources = [
            { name = "vim-vsnip"; }
            { name = "vim-lsp-signature-help"; }
            { name = "nvim-lsp"; }
            { name = "treesitter"; }
            { name = "buffer"; }
          ];
          mapping = {
            "<C-Space>" = "cmp.mapping.complete()";
            "<C-e>" = "cmp.mapping.close()";
            "<CR>" = "cmp.mapping.confirm({ select = true })";
            "<C-Tab>" = "cmp.mapping(cmp.mapping.select_prev_item(), {'i', 's'})";
            "<Tab>" = "cmp.mapping(cmp.mapping.select_next_item(), {'i', 's'})";
          };
        };
      };
      friendly-snippets.enable = true;
      nvim-autopairs.enable = true;

      lsp = {
        enable = true;
        keymaps = {
          diagnostic = {
            "<leader>j" = {
              action = "goto_next";
              desc = "Next Diagnostic";
            };
            "<leader>k" = {
              action = "goto_prev";
              desc = "Previous Diagnostic";
            };
            "<leader>K" = {
              action = "open_float";
              desc = "Line Diagnostics";
            };
          };
          lspBuf = {
            gd = {
              action = "definition";
              desc = "Goto Definition";
            };
            gr = {
              action = "references";
              desc = "Goto References";
            };
            gD = {
              action = "declaration";
              desc = "Goto Declaration";
            };
            gI = {
              action = "implementation";
              desc = "Goto Implementation";
            };
            gT = {
              action = "type_definition";
              desc = "Type Definition";
            };
            K = {
              action = "hover";
              desc = "Hover";
            };
          };
        };
        servers = {
          clangd.enable = true;
          cmake.enable = true;
          dockerls.enable = true;
          docker_compose_language_service.enable = true;
          eslint.enable = true;
          html.enable = true;
          jsonls.enable = true;
          nixd.enable = true;
          pylsp.enable = true;
          rust_analyzer = {
            enable = true;
            installCargo = true;
            installRustc = true;
          };
          yamlls.enable = true;
        };
      };
      lsp-format.enable = true;
      lsp-lines.enable = true;
    };
  };
}
