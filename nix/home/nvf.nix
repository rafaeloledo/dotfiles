{ ... }:

{
	programs.nvf = {
		enable = true;
		settings = {
			vim = {
				theme = {
					enable = true;
					name = "onedark";
					style = "dark";
				};

				viAlias = false;
				vimAlias = true;

				lsp = {
					enable = true;
				};

				statusline.lualine.enable = true;
				telescope.enable = true;
				autocomplete.nvim-cmp.enable = true;

				languages = {
					enableLSP = true;
					enableTreesitter = true;

					nix.enable = true;
					ts.enable = true;
					rust.enable = true;
				};

        binds.whichKey.enable = true;
        options.shiftwidth = 2;

        filetree.neo-tree.enable = true;
			};
		};
	};
}
