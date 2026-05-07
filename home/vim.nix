{ config, pkgs, inputs, lib, ... }:
{
  imports = [ inputs.nixvim.homeModules.nixvim ];

  programs.nixvim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;

    colorschemes.catppuccin = {
      enable = true;
      settings = {
        transparent_background = true;
        flavour = "mocha";
      };
    };

    opts = {
      number = true;
      shiftwidth = 2;
      mouse = "a";
      expandtab = true;
      smartindent = true;
    };

    plugins = {
      lsp = {
        enable = true;
        servers = {
          lemminx.enable = true;
          nil_ls.enable = true;
          omnisharp.enable = true;
        };
      };

      cmp = {
        enable = true;
        settings.sources = [
          { name = "nvim_lsp"; }
          { name = "path"; }
          { name = "buffer"; }
        ];
        settings.mapping = {
          "<Tab>" = "cmp.mapping(cmp.mapping.select_next_item(), {'i', 's'})";
          "<CR>" = "cmp.mapping.confirm({ select = true })";
        };
      };

      treesitter = {
        enable = true;
        grammarPackages = pkgs.vimPlugins.nvim-treesitter.allGrammars;
        settings.highlight.enable = true;
        settings.indent.enable = true;
        settings.auto_install = false;
      };

      neo-tree = {
        enable = true;
        settings = {
          close_if_last_window = true;
          enable_git_status = true;
          enable_diagnostics = true;
          filesystem = {
            filtered_items = {
              visible = true;
              hide_dotfiles = false;
            };
            follow_current_file = {
              enabled = true;
            };
          };
          window = {
            position = "left";
            width = 25;
          };
        };
      };

      lualine.enable = true;
      indent-blankline.enable = true;
      which-key.enable = true;
      gitsigns.enable = true;
      nvim-autopairs.enable = true;
      toggleterm.enable = true;
    };

    autoCmd = [
      {
        event = [ "VimEnter" ];
        callback = {
          __raw = ''
            function()
              if vim.fn.argc() == 0 then
                vim.cmd("Neotree show")
              end
            end
          '';
        };
      }
    ];

    extraCinfigLua = ''
    '';
  };
}
