# LaTeX Cheat Sheet — Math Proofs

Quick reference for 6.1200J-style discrete math / proof writing.
Close this window with `q` or `<Esc>`.

---

## Document Skeleton

```latex
\documentclass[11pt]{article}
\usepackage{amsmath, amssymb, amsthm, mathtools}
\usepackage[margin=1in]{geometry}

\newtheorem{theorem}{Theorem}
\newtheorem{lemma}{Lemma}
\newtheorem{claim}{Claim}

\begin{document}
\title{Pset N}
\author{Michael Duren}
\maketitle

\section*{Problem 1}
...

\end{document}
```

## Math Mode

| Source                | Renders     |
|-----------------------|-------------|
| `$x^2$`               | inline      |
| `\[ x^2 \]`           | display     |
| `\begin{align*} ... \end{align*}` | multiline, no numbers |
| `\begin{equation} ... \end{equation}` | numbered |

## Common Symbols

### Logic
| Symbol | LaTeX            |
|--------|------------------|
| ∀      | `\forall`        |
| ∃      | `\exists`        |
| ¬      | `\neg`           |
| ∧      | `\land`          |
| ∨      | `\lor`           |
| ⇒      | `\implies`       |
| ⇔      | `\iff`           |
| ⊢      | `\vdash`         |
| ≡      | `\equiv`         |

### Sets
| Symbol | LaTeX             |
|--------|-------------------|
| ∈ ∉    | `\in` `\notin`    |
| ⊂ ⊆    | `\subset` `\subseteq` |
| ∪ ∩    | `\cup` `\cap`     |
| ∅      | `\emptyset` / `\varnothing` |
| ℕ ℤ ℚ ℝ ℂ | `\mathbb{N}` `\mathbb{Z}` ... |
| \|A\|  | `\lvert A \rvert` |
| {x : P(x)} | `\{ x : P(x) \}` |

### Relations / Operators
| Symbol | LaTeX             |
|--------|-------------------|
| ≤ ≥    | `\leq` `\geq`     |
| ≠      | `\neq`            |
| ≈      | `\approx`         |
| ∼      | `\sim`            |
| ⋅      | `\cdot`           |
| ×      | `\times`          |
| ±      | `\pm`             |
| ∑ ∏    | `\sum` `\prod`    |
| ∫      | `\int`            |
| lim    | `\lim_{n \to \infty}` |

### Greek Letters
`\alpha \beta \gamma \delta \epsilon \varepsilon \zeta \eta \theta`
`\iota \kappa \lambda \mu \nu \xi \pi \rho \sigma \tau`
`\upsilon \phi \varphi \chi \psi \omega`
Capitals: `\Gamma \Delta \Theta \Lambda \Xi \Pi \Sigma \Phi \Psi \Omega`

### Number Theory
| Notation        | LaTeX                       |
|-----------------|-----------------------------|
| a divides b     | `a \mid b`                  |
| a ≡ b (mod n)   | `a \equiv b \pmod{n}`       |
| gcd(a,b)        | `\gcd(a,b)`                 |
| floor / ceil    | `\lfloor x \rfloor` `\lceil x \rceil` |

## Fractions, Roots, Powers

```latex
\frac{a}{b}       % small in inline, big in display
\dfrac{a}{b}      % always big
\sqrt{x}          % square root
\sqrt[n]{x}       % n-th root
x^{n}             % superscript (braces if >1 char)
x_{i,j}           % subscript
```

## Environments

### Proof
```latex
\begin{proof}
  Suppose $n$ is even. Then $n = 2k$ for some $k \in \mathbb{Z}$.
  ...
  Therefore $n^2$ is even. \qedhere
\end{proof}
```

### Cases
```latex
f(x) =
\begin{cases}
  x       & \text{if } x \geq 0 \\
  -x      & \text{otherwise}
\end{cases}
```

### Induction skeleton
```latex
\textbf{Base case.} Show $P(0)$ holds. ...

\textbf{Inductive step.} Assume $P(k)$ for some $k \geq 0$.
We show $P(k+1)$. ...

By induction, $P(n)$ holds for all $n \geq 0$. \qed
```

### Aligned equations
```latex
\begin{align*}
  (a+b)^2 &= (a+b)(a+b) \\
          &= a^2 + 2ab + b^2
\end{align*}
```

## Text Inside Math

```latex
$x > 0 \text{ implies } x^2 > 0$    % \text{...} for words
\quad  \qquad                         % small / large spacing
\,     \;     \!                      % thin space, thick space, neg space
```

## Useful Macros to Define

```latex
\newcommand{\N}{\mathbb{N}}
\newcommand{\Z}{\mathbb{Z}}
\newcommand{\Q}{\mathbb{Q}}
\newcommand{\R}{\mathbb{R}}
\newcommand{\set}[1]{\{#1\}}
\DeclareMathOperator{\lcm}{lcm}
```

## Snippet Triggers (from your `snippets/tex.lua`)

| Trigger  | Expands to              |
|----------|-------------------------|
| `mk`     | `$ . $` inline math     |
| `dm`     | `\[ . \]` display math  |
| `beg`    | `\begin{env}...\end{env}` |
| `proof`  | proof environment       |
| `ali`    | `align*` block          |
| `set`    | `\{ . \}`               |
| `forall` `exists` `implies` `iff` | the symbol |

## Vimtex Mappings (leader = `\`)

| Map | Command            | Effect                       |
|-----|--------------------|------------------------------|
| `\ll` | `:VimtexCompile` | Toggle continuous compile    |
| `\lv` | `:VimtexView`    | Open / forward-sync Zathura  |
| `\le` | `:VimtexErrors`  | Show compile log             |
| `\lk` | `:VimtexStop`    | Stop compile                 |
| `\lc` | `:VimtexClean`   | Remove aux files             |
| `\li` | `:VimtexInfo`    | Plugin status                |
| `]]` `[[` | -            | Jump between sections        |

## User Commands

| Command          | Effect                                    |
|------------------|-------------------------------------------|
| `:ProofTemplate` | Replace current buffer with proof template |
