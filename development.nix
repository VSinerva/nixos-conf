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
        options.silent = true;
      }
      {
        key = "<C-h>";
        action = "<cmd>TmuxNavigateLeft<cr>";
        options.silent = true;
      }
      {
        key = "<C-j>";
        action = "<cmd>TmuxNavigateDown<cr>";
        options.silent = true;
      }
      {
        key = "<C-k>";
        action = "<cmd>TmuxNavigateUp<cr>";
        options.silent = true;
      }
      {
        key = "<C-l>";
        action = "<cmd>TmuxNavigateRight<cr>";
        options.silent = true;
      }
    ];

    # TODO Check desireable keybinds and commands for all plugins
    plugins = {
      gitsigns.enable = true;
      lualine = {
        enable = true;
        settings.options.iconsEnabled = false;
      };
      markdown-preview.enable = true;
      neo-tree.enable = true;
      nix.enable = true;
      rainbow-delimiters.enable = true;
      sleuth.enable = true;
      tmux-navigator = {
        enable = true;
        settings.no_mappings = 1;
      };
      treesitter = {
        enable = true;
        folding = true;
        settings.indent.enable = true;
        nixGrammars = true;
      };
      web-devicons.enable = true;

      cmp = {
        enable = true;
        settings.sources = [
          { name = "nvim-lsp"; }
          { name = "vim-lsp-signature-help"; }
          { name = "vim-vsnip"; }
        ];
      };
      friendly-snippets.enable = true;
      nvim-autopairs.enable = true;

      lsp = {
        enable = true;
        keymaps = {
          diagnostic = {
            "<leader>j" = "goto_next";
            "<leader>k" = "goto_prev";
          };
          lspBuf = {
            K = "hover";
            gD = "references";
            gd = "definition";
            gi = "implementation";
            gt = "type_definition";
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
    };
  };
}
