require('nvim-treesitter.configs').setup {
	ensure_installed = {
		'lua', 'python', 'rust', 'typescript',
		'markdown', 'markdown_inline', 'sql',
		'org', 'html', 'css', 'javascript',
		'yaml', 'json', 'toml', 'vim', 'vimdoc', 'query'
	},
	highlight = { enable = true },
	indent = { enable = true },
}
