-- currently disabled everywhere; flip this to re-enable on non-Linux
if true then
	return {}
end

return {
	"shortcuts/no-neck-pain.nvim",
	opts = {
		width = 180,
		autocmds = {
			enableOnVimEnter = true,
		},
	},
}
