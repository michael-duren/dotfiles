-- :ProofTemplate — drop a math-proof LaTeX skeleton into the current buffer.
-- Useful for 6.1200J pset problems. Run in an empty .tex buffer; aborts if the
-- buffer already has content unless called with !  (:ProofTemplate!).
vim.api.nvim_create_user_command("ProofTemplate", function(opts)
	local buf = vim.api.nvim_get_current_buf()
	local line_count = vim.api.nvim_buf_line_count(buf)
	local first_line = vim.api.nvim_buf_get_lines(buf, 0, 1, false)[1] or ""
	local is_empty = line_count == 1 and first_line == ""

	if not is_empty and not opts.bang then
		vim.notify("Buffer is not empty. Use :ProofTemplate! to overwrite.", vim.log.levels.WARN)
		return
	end

	local template = {
		[[\documentclass[11pt]{article}]],
		[[\usepackage{amsmath, amssymb, amsthm, mathtools}]],
		[[\usepackage[margin=1in]{geometry}]],
		[[]],
		[[% Shortcuts]],
		[[\newcommand{\N}{\mathbb{N}}]],
		[[\newcommand{\Z}{\mathbb{Z}}]],
		[[\newcommand{\Q}{\mathbb{Q}}]],
		[[\newcommand{\R}{\mathbb{R}}]],
		[[\newcommand{\set}[1]{\{#1\}}]],
		[[]],
		[[% Theorem-like environments]],
		[[\newtheorem{theorem}{Theorem}]],
		[[\newtheorem{lemma}{Lemma}]],
		[[\newtheorem{claim}{Claim}]],
		[[\theoremstyle{definition}]],
		[[\newtheorem{definition}{Definition}]],
		[[]],
		[[\title{Problem Set N}]],
		[[\author{Michael Duren}]],
		[[\date{\today}]],
		[[]],
		[[\begin{document}]],
		[[\maketitle]],
		[[]],
		[[\section*{Problem 1}]],
		[[]],
		[[\textbf{Claim.} Replace this with the statement you are proving.]],
		[[]],
		[[\begin{proof}]],
		[[  Write your proof here. Useful starting moves:]],
		[[  \begin{itemize}]],
		[[    \item \emph{Direct:} Assume the hypothesis, derive the conclusion.]],
		[[    \item \emph{Contrapositive:} Assume $\neg Q$, derive $\neg P$.]],
		[[    \item \emph{Contradiction:} Assume $P \land \neg Q$, derive a contradiction.]],
		[[    \item \emph{Induction:} Base case $n = 0$, then $P(k) \implies P(k+1)$.]],
		[[  \end{itemize}]],
		[[]],
		[[  Example display equation:]],
		[[  \[]],
		[[    \sum_{i=1}^{n} i = \frac{n(n+1)}{2}.]],
		[==[  \]]==],
		[[]],
		[[  Conclude with what was shown. \qedhere]],
		[[\end{proof}]],
		[[]],
		[[\end{document}]],
	}

	vim.api.nvim_buf_set_lines(buf, 0, -1, false, template)
	if vim.bo[buf].filetype == "" then
		vim.bo[buf].filetype = "tex"
	end
end, {
	bang = true,
	desc = "Insert a LaTeX math-proof template into the current buffer",
})
