return {
	-- LSP Configuration
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			-- Additional lua configuration for neovim
			"folke/neodev.nvim",
		},
		config = function()
			local lspconfig = require("lspconfig")

			-- Setup neovim lua configuration
			require("neodev").setup()

			-- Configure LSP servers (assuming they are already installed on the system)
			local servers = {
				"lua_ls",
				"pyright",
				"ts_ls",
				"clangd",
				-- Add more servers as needed
			}

			-- Setup LSP keymaps only when LSP attaches
			vim.api.nvim_create_autocmd("LspAttach", {
				group = vim.api.nvim_create_augroup("UserLspConfig", {}),
				callback = function(ev)
					local opts = { buffer = ev.buf }

					-- Navigate diagnostics
					vim.keymap.set("n", "[d", function()
						vim.diagnostic.jump_prev()
					end, { desc = "Previous diagnostic" })
					vim.keymap.set("n", "]d", function()
						vim.diagnostic.jump_next()
					end, { desc = "Next diagnostic" })
					vim.keymap.set("n", "<leader>cd", vim.diagnostic.open_float, { desc = "Line diagnostics" })
					vim.keymap.set("n", "<leader>cq", vim.diagnostic.setloclist, { desc = "Quickfix diagnostics" })

					-- LSP actions
					vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
					vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
					vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
					vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
					vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
					vim.keymap.set("n", "<leader>ch", vim.lsp.buf.signature_help, opts)
					vim.keymap.set("n", "<leader>cr", vim.lsp.buf.rename, { desc = "Rename symbol" })
					vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "Code action" })
					vim.keymap.set("n", "<leader>cf", function()
						vim.lsp.buf.format({ async = true })
					end, { desc = "Format document" })
				end,
			})

			-- Configure diagnostics display
			vim.diagnostic.config({
				virtual_text = true,
				signs = true,
				underline = true,
				update_in_insert = false,
				severity_sort = true,
			})

			-- Default capabilities with nvim-cmp LSP capabilities
			local capabilities = vim.lsp.protocol.make_client_capabilities()
			capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

			-- Setup all external LSP servers
			for _, server in ipairs(servers) do
				local server_opts = {
					capabilities = capabilities,
				}

				-- Server specific overrides
				if server == "lua_ls" then
					server_opts.settings = {
						Lua = {
							diagnostics = {
								globals = { "vim" },
							},
							workspace = {
								library = vim.api.nvim_get_runtime_file("", true),
								checkThirdParty = false,
							},
							telemetry = {
								enable = false,
							},
						},
					}
				end

				-- Initialize the LSP
				lspconfig[server].setup(server_opts)
			end
		end,
	},

	-- Autocompletion
	{
		"hrsh7th/nvim-cmp",
		dependencies = {
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-path",
			"hrsh7th/cmp-cmdline",
			"L3MON4D3/LuaSnip",
			"saadparwaiz1/cmp_luasnip",
		},
		config = function()
			local cmp = require("cmp")
			local luasnip = require("luasnip")

			cmp.setup({
				snippet = {
					expand = function(args)
						luasnip.lsp_expand(args.body)
					end,
				},
				mapping = cmp.mapping.preset.insert({
					["<C-b>"] = cmp.mapping.scroll_docs(-4),
					["<C-f>"] = cmp.mapping.scroll_docs(4),
					["<C-Space>"] = cmp.mapping.complete(),
					["<C-e>"] = cmp.mapping.abort(),
					["<CR>"] = cmp.mapping.confirm({ select = true }),
				}),
				sources = cmp.config.sources({
					{ name = "nvim_lsp" },
					{ name = "luasnip" },
				}, {
					{ name = "buffer" },
					{ name = "path" },
				}),
			})

			-- Use buffer source for `/` and `?`
			cmp.setup.cmdline({ "/", "?" }, {
				mapping = cmp.mapping.preset.cmdline(),
				sources = {
					{ name = "buffer" },
				},
			})

			-- Use cmdline & path source for ':'
			cmp.setup.cmdline(":", {
				mapping = cmp.mapping.preset.cmdline(),
				sources = cmp.config.sources({
					{ name = "path" },
				}, {
					{ name = "cmdline" },
				}),
			})
		end,
	},

	{
		"nvim-flutter/flutter-tools.nvim",
		lazy = false,
		dependencies = {
			"nvim-lua/plenary.nvim",
			"stevearc/dressing.nvim", -- optional for vim.ui.select
		},
		config = true,
		opts = {},
	},
}
