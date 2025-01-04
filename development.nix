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
        options.desc = "Open Neotree";
      }
      {
        mode = [
          "i"
          "v"
        ];
        key = "<C-c>";
        action = "<Esc>";
        options.desc = "Exit To Normal Mode";
      }
      {
        key = "<leader>b";
        action = "<cmd>Gitsigns toggle_current_line_blame<cr>";
        options.desc = "Toggle Current Line Git Blame";
      }
    ];

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
        inlayHints = true;
        keymaps = {
          diagnostic = {
            "<leader>dj" = {
              action = "goto_next";
              desc = "Next Diagnostic";
            };
            "<leader>dk" = {
              action = "goto_prev";
              desc = "Previous Diagnostic";
            };
            "<leader>dh" = {
              action = "open_float";
              desc = "Line Diagnostics";
            };
          };
          lspBuf = {
            "<leader>gd" = {
              action = "definition";
              desc = "Goto Definition";
            };
            "<leader>gr" = {
              action = "references";
              desc = "Goto References";
            };
            "<leader>gD" = {
              action = "declaration";
              desc = "Goto Declaration";
            };
            "<leader>gi" = {
              action = "implementation";
              desc = "Goto Implementation";
            };
            "<leader>gt" = {
              action = "type_definition";
              desc = "Type Definition";
            };
            "<leader>s" = {
              action = "workspace_symbol";
              desc = "Search Symbol";
            };
            "<leader>r" = {
              action = "rename";
              desc = "Rename Symbol";
            };
            "<leader>a" = {
              action = "code_action";
              desc = "Code Action";
            };
            H = {
              action = "hover";
              desc = "Hover";
            };
          };
          extra = [
            {
              action = "<cmd>lua vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())<cr>";
              key = "<leader>h";
              options.desc = "Toggle LSP Inlay Hints";
            }
          ];
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
      lsp-signature.enable = true;
    };
  };
}
