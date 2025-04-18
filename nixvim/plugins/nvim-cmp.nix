{
  config,
  pkgs,
  inputs,
  ...
}:

{
  programs.nixvim = {
    # Dependencies
    #
    # Snippet Engine & its associated nvim-cmp source
    # https://nix-community.github.io/nixvim/plugins/luasnip/index.html
    plugins.luasnip = {
      enable = true;
    };

    # https://nix-community.github.io/nixvim/plugins/cmp-nvim-lsp.html
    plugins.cmp-nvim-lsp = {
      enable = true;
    };

    # https://nix-community.github.io/nixvim/plugins/cmp-path.html
    plugins.cmp-path = {
      enable = true;
    };

    plugins.codeium-nvim = {
      enable = true;
    };

    # `friendly-snippets` contains a variety of premade snippets
    #    See the README about individual language/framework/plugin snippets:
    #    https://github.com/rafamadriz/friendly-snippets
    # https://nix-community.github.io/nixvim/plugins/friendly-snippets.html
    # plugins.friendly-snippets = {
    #   enable = true;
    # };

    # TODO: Waiting on this bug to be fixed https://github.com/NixOS/nixpkgs/issues/306367
    # https://nix-community.github.io/nixvim/NeovimOptions/index.html?highlight=extralua#extraluapackages
    extraLuaPackages = ps: [
      # Required by luasnip
      ps.jsregexp
    ];

    # Autocompletion
    # See `:help cmp`
    # https://nix-community.github.io/nixvim/plugins/cmp/index.html
    plugins.cmp = {
      enable = true;

      settings = {
        snippet = {
          expand = ''
            function(args)
              require('luasnip').lsp_expand(args.body)
            end
          '';
        };

        completion = {
          completeopt = "menu,menuone,noinsert";
        };

        # For an understanding of why these mappings were
        # chosen, you will need to read `:help ins-completion`
        #
        # No, but seriously, Please read `:help ins-completion`, it is really good!
        mapping = {
          # Select the [n]ext item
          "<TAB>" = "cmp.mapping.select_next_item()";
          "<down>" = "cmp.mapping.select_next_item()";
          # Select the [p]revious item
          "<S-TAB>" = "cmp.mapping.select_prev_item()";
          "<up>" = "cmp.mapping.select_prev_item()";
          # Scroll the documentation window [b]ack / [f]orward
          "<C-b>" = "cmp.mapping.scroll_docs(-4)";
          "<C-f>" = "cmp.mapping.scroll_docs(4)";
          # Accept ([y]es) the completion.
          #  This will auto-import if your LSP supports it.
          #  This will expand snippets if the LSP sent a snippet.
          "<CR>" = "cmp.mapping.confirm { select = true }";
          # If you prefer more traditional completion keymaps,
          # you can uncomment the following lines.
          # "<CR>" = "cmp.mapping.confirm { select = true }";
          # "<Tab>" = "cmp.mapping.select_next_item()";
          # "<S-Tab>" = "cmp.mapping.select_prev_item()";

          # Manually trigger a completion from nvim-cmp.
          #  Generally you don't need this, because nvim-cmp will display
          #  completions whenever it has completion options available.
          "<C-Space>" = "cmp.mapping.complete {}";

          # Think of <c-l> as moving to the right of your snippet expansion.
          #  So if you have a snippet that's like:
          #  function $name($args)
          #    $body
          #  end
          #
          # <c-l> will move you to the right of the expansion locations.
          # <c-h> is similar, except moving you backwards.
          "<C-l>" = ''
            cmp.mapping(function()
              if luasnip.expand_or_locally_jumpable() then
                luasnip.expand_or_jump()
              end
            end, { 'i', 's' })
          '';
          "<C-h>" = ''
            cmp.mapping(function()
              if luasnip.locally_jumpable(-1) then
                luasnip.jump(-1)
              end
            end, { 'i', 's' })
          '';

          # For more advanced Luasnip keymaps (e.g. selecting choice nodes, expansion) see:
          #    https://github.com/L3MON4D3/LuaSnip?tab=readme-ov-file#keymaps
        };

        # WARNING: If plugins.cmp.autoEnableSources Nixivm will automatically enable the 
        # corresponding source plugins. This will work only when this option is set to a list.
        # If you use a raw lua string, you will need to explicitly enable the relevant source
        # plugins in your nixvim configuration.
        sources = [
          { name = "luasnip"; }
          # Adds other completion capabilites.
          #  nvim-cmp does not ship with all sources by default. They are split
          #  into multiple repos for maintenance purposes.
          { name = "nvim_lsp"; }
          { name = "path"; }
          { name = "codeium"; }
        ];
      };
    };
  };
}
