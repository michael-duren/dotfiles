-- Math & logic symbols available in ALL filetypes
-- Place this file at: ~/.config/nvim/luasnippets/all.lua
-- Requires LuaSnip: https://github.com/L3MON4D3/LuaSnip
--
-- Usage: type the trigger (e.g. \exists) then press your LuaSnip expand key

local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node

return {

	-- ── Logic ────────────────────────────────────────────────────────────
	s("\\exists", t("∃")), -- there exists
	s("\\nexists", t("∄")), -- there does not exist
	s("\\forall", t("∀")), -- for all
	s("\\neg", t("¬")), -- negation
	s("\\and", t("∧")), -- logical and
	s("\\or", t("∨")), -- logical or
	s("\\implies", t("⟹")), -- implies
	s("\\iff", t("⟺")), -- if and only if
	s("\\therefore", t("∴")), -- therefore
	s("\\because", t("∵")), -- because

	-- ── Relations ────────────────────────────────────────────────────────
	s("\\equiv", t("≡")), -- congruence / equivalence
	s("\\neq", t("≠")), -- not equal
	s("\\leq", t("≤")), -- less than or equal
	s("\\geq", t("≥")), -- greater than or equal
	s("\\approx", t("≈")), -- approximately equal
	s("\\sim", t("∼")), -- similar to
	s("\\cong", t("≅")), -- congruent to
	s("\\propto", t("∝")), -- proportional to

	-- ── Set theory ───────────────────────────────────────────────────────
	s("\\in", t("∈")), -- element of
	s("\\notin", t("∉")), -- not element of
	s("\\subset", t("⊂")), -- proper subset
	s("\\subseteq", t("⊆")), -- subset or equal
	s("\\supset", t("⊃")), -- proper superset
	s("\\supseteq", t("⊇")), -- superset or equal
	s("\\union", t("∪")), -- union
	s("\\inter", t("∩")), -- intersection
	s("\\empty", t("∅")), -- empty set
	-- ── Number sets (blackboard bold) ────────────────────────────────────
	s("\\NN", t("ℕ")), -- natural numbers
	s("\\ZZ", t("ℤ")), -- integers
	s("\\QQ", t("ℚ")), -- rationals
	s("\\RR", t("ℝ")), -- reals
	s("\\CC", t("ℂ")), -- complex
	s("\\PP", t("ℙ")), -- primes
	-- ── Arrows ───────────────────────────────────────────────────────────
	s("\\to", t("→")), -- right arrow
	s("\\gets", t("←")), -- left arrow
	s("\\upto", t("↑")), -- up arrow
	s("\\downto", t("↓")), -- down arrow
	s("\\leftrigh", t("↔")), -- left right arrow

	-- ── Math ops ─────────────────────────────────────────────────────────
	s("\\inf", t("∞")), -- infinity
	s("\\sum", t("∑")), -- summation
	s("\\prod", t("∏")), -- product
	s("\\sqrt", t("√")), -- square root
	s("\\pm", t("±")), -- plus minus
	s("\\times", t("×")), -- multiplication
	s("\\div", t("÷")), -- division
	s("\\cdot", t("·")), -- center dot
	s("\\partial", t("∂")), -- partial derivative
	s("\\nabla", t("∇")), -- nabla / gradient
	s("\\integral", t("∫")), -- integral

	-- ── Greek (commonly used in proofs/algorithms) ────────────────────────
	s("\\alpha", t("α")),
	s("\\beta", t("β")),
	s("\\gamma", t("γ")),
	s("\\delta", t("δ")),
	s("\\epsilon", t("ε")),
	s("\\theta", t("θ")),
	s("\\lambda", t("λ")),
	s("\\mu", t("μ")),
	s("\\pi", t("π")),
	s("\\sigma", t("σ")),
	s("\\tau", t("τ")),
	s("\\phi", t("φ")),
	s("\\omega", t("ω")),
	s("\\Omega", t("Ω")),
}
