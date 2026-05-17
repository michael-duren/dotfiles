local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local fmt = require("luasnip.extras.fmt").fmt

return {
	-- inline math:  mk -> $ . $
	s("mk", fmt("${}$ ", { i(1) })),
	-- display math
	s("dm", fmt("\\[\n  {}\n\\]", { i(1) })),
	-- environments
	s("beg", fmt("\\begin{{{}}}\n  {}\n\\end{{{}}}", { i(1, "env"), i(2), require("luasnip.extras").rep(1) })),
	-- proof skeleton
	s("proof", fmt("\\begin{{proof}}\n  {}\n\\end{{proof}}", { i(1) })),
	-- align (multi-line math)
	s("ali", fmt("\\begin{{align*}}\n  {} &= {}\n\\end{{align*}}", { i(1), i(2) })),
	-- common 6.1200 things
	s("set", fmt("\\{{{}\\}}", { i(1) })),
	s("forall", t("\\forall ")),
	s("exists", t("\\exists ")),
	-- proof skeleton
	s("proof", fmt("\\begin{{proof}}\n  {}\n\\end{{proof}}", { i(1) })),
	-- align (multi-line math)
	s("ali", fmt("\\begin{{align*}}\n  {} &= {}\n\\end{{align*}}", { i(1), i(2) })),
	-- common 6.1200 things
	s("set", fmt("\\{{{}\\}}", { i(1) })),
	s("forall", t("\\forall ")),
	s("exists", t("\\exists ")),
	s("implies", t("\\implies ")),
	s("iff", t("\\iff ")),
	-- logical operators
	s("or", t("\\vee ")),
	s("and", t("\\wedge ")),
	s("not", t("\\neg ")),
	-- set membership and number sets
	s("in", t("\\in ")),
	s("NN", t("\\mathbb{N}")),
	-- text mode inside math
	s("txt", fmt("\\text{{{}}}", { i(1) })),
}
