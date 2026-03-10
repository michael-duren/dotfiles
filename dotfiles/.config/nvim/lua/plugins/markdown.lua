return {
	{
		"MeanderingProgrammer/render-markdown.nvim",
		dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-mini/mini.nvim" },
		---@module 'render-markdown'
		---@type render.md.UserConfig
		opts = {
			-- Enable for octo.nvim buffers
			file_types = { "markdown", "octo" },
			
			-- Conceal HTML tags in markdown/octo buffers
			html = {
				enabled = true,
			},
			
			-- Better rendering for GitHub-flavored markdown
			render_modes = { "n", "c", "v", "i" },
			
			-- GitHub-style checkboxes
			checkbox = {
				enabled = true,
				unchecked = { icon = "󰄱 " },
				checked = { icon = " " },
			},
			
			-- Better code block rendering
			code = {
				enabled = true,
				sign = false,
				style = "normal",
				position = "left",
				width = "block",
				left_pad = 0,
				right_pad = 0,
			},
			
			-- Bullet points
			bullet = {
				enabled = true,
				icons = { "●", "○", "◆", "◇" },
			},
		},
	},
}
