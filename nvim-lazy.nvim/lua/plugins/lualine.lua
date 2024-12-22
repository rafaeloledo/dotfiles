require("lualine").setup{
	options = {
    icons_enabled = true,
    component_separators = '|',
    section_separators = '',
  },
	sections = {
		lualine_a = {
			{
				'buffers',
				symbols = { alternate_file = '' },
			},
		},
		lualine_b = { 'branch' },
		lualine_c = { '' },
		lualine_x = {
			'encoding',
			{
				'fileformat',
				symbols = {
					unix = '󰻀\u{2009}',
					dos = '\u{2009}',
				},
			},
		},
		lualine_y = { '' },
	},
}
