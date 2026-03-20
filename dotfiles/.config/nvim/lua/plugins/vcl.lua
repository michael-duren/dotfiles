return {
	-- Syntax highlighting for Varnish/Fastly VCL.
	-- Maintained by the official varnishcache-friends org, explicitly supports Neovim.
	-- Provides ftdetect/, ftplugin/, and syntax/ for the vcl filetype.
	-- Loaded lazily — only when a vcl buffer is opened.
	"varnishcache-friends/vim-varnish",
	ft = "vcl",
}
