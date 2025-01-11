if vim.fn.has 'win32' then
	vim.cmd [[
			let &shell = executable('pwsh') ? 'pwsh' : 'powershell'
			let &shellcmdflag = '-NoLogo -ExecutionPolicy RemoteSigned -Command [Console]::InputEncoding=[Console]::OutputEncoding=[System.Text.UTF8Encoding]::new();$PSDefaultParameterValues[''Out-File:Encoding'']=''utf8'';Remove-Alias -Force -ErrorAction SilentlyContinue tee;'
			let &shellredir = '2>&1 | %%{ "$_" } | Out-File %s; exit $LastExitCode'
			let &shellpipe  = '2>&1 | %%{ "$_" } | tee %s; exit $LastExitCode'
			set shellquote= shellxquote=
	]]
end


require('toggleterm').setup{
	open_mapping = '<C-\\>',
	star_in_insert = true,
	direction = "float",
}
