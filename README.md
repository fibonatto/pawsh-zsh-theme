# >ﻌ< Pawsh ZSH Theme

Pawsh is a lightweight ZSH theme for plain zsh environments. It provides a minimal prompt centered on fast git status display, vi mode awareness, virtualenv visibility, and command result feedback.

![Pawsh Theme Example](https://github.com/SergioBonatto/pawsh-zsh-theme/blob/main/assets/example.png?raw=true)

---

# Features

* Cat prompt (`>ﻌ<`) changes color according to command exit status:

  * cyan on success
  * red on failure
* Root indicator (`#`) in magenta
* Current directory displayed in cyan
* Active Python virtualenv shown when present
* Vi mode indicator `[N]` in normal mode
* Git branch information in prompt
* Detailed repository state in right prompt:

  * staged files
  * modified files
  * untracked files
  * deleted files
  * ahead / behind counters
  * merge / rebase / cherry-pick / bisect states
  * conflict detection
* Prompt refresh on keymap change using ZLE hooks
* No framework dependency

---

# Installation

Clone the repository:

```bash
git clone https://github.com/SergioBonatto/pawsh-zsh-theme.git
cd pawsh-zsh-theme
```

Create a local themes directory:

```bash
mkdir -p ~/.zsh/themes
```

Copy the theme file:

```bash
cp pawsh.zsh-theme ~/.zsh/themes/
```

Load the theme in `~/.zshrc`:

```bash
source ~/.zsh/themes/pawsh.zsh-theme
```

Reload the shell:

```bash
source ~/.zshrc
```

If you use zsh bytecode compilation:

```bash
zcompile ~/.zshrc
```

---

# Requirements

* `zsh`
* `git`
* Terminal with Unicode support

---

# Prompt Structure

Left prompt:

```text
>ﻌ< directory git:(branch)
```

Right prompt:

```text
branch +staged ~modified -deleted ?untracked ↑ahead ↓behind
```

---

# Customization

The theme uses these prompt variables:

* `ZSH_THEME_GIT_PROMPT_PREFIX`
* `ZSH_THEME_GIT_PROMPT_SUFFIX`
* `ZSH_THEME_GIT_PROMPT_DIRTY`
* `ZSH_THEME_GIT_PROMPT_CLEAN`

To change colors or symbols, edit:

```bash
pawsh.zsh-theme
```

---

# Notes

Pawsh is designed for direct sourcing in plain zsh.

It does not require:

* Oh My Zsh
* plugin managers
* external prompt engines

---

# Contributing

Pull requests and issue reports are welcome.

---

# License

MIT
