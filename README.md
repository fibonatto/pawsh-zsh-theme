# Pawsh ZSH Theme >ﻌ< 

Pawsh is a small ZSH prompt for people who just want their shell to look nice and tell them what is going on.

It shows the stuff that matters without turning your prompt into a dashboard:

* command status
* current directory
* vi mode
* Python virtualenv
* git state

![Pawsh Theme Example](https://github.com/SergioBonatto/pawsh-zsh-theme/blob/main/assets/example.png?raw=true)

## Features

### Prompt

The cat changes color depending on the last command:

* yellow when it succeeds
* red when it fails

The current directory is shown when you're not in `$HOME`.

Root shells get a `#` indicator.

### Git

Git information lives on the right side of the prompt:

```text
[main +1 ~2 -1 ?3 ↑1 ↓2]
```

Where:

* `+` staged files
* `~` modified files
* `-` deleted files
* `?` untracked files
* `↑` commits ahead
* `↓` commits behind
* `!` conflicts

The branch is:

* green when clean
* yellow when dirty
* red when conflicts exist

Pawsh also detects:

* merge
* rebase
* cherry-pick
* bisect

Git status is collected once per prompt refresh.

### Vi mode

Normal mode is shown as:

```text
(N)
```

It appears on the right side of the prompt and updates when the ZLE keymap changes.

### Python virtualenv

An active virtualenv is shown on the right:

```text
(main) (project)
```

The usual `.venv`, `venv`, and `env` names are replaced with their parent directory name when possible.

Pawsh also disables the virtualenv activation script's own prompt modification, so you don't get two environment indicators.

## Installation

Clone the repository:

```bash
git clone https://github.com/SergioBonatto/pawsh-zsh-theme.git
cd pawsh-zsh-theme
```

Create a themes directory:

```bash
mkdir -p ~/.zsh/themes
```

Copy the theme:

```bash
cp pawsh.zsh-theme ~/.zsh/themes/
```

Source it from `~/.zshrc`:

```zsh
source ~/.zsh/themes/pawsh.zsh-theme
```

Then reload ZSH:

```bash
source ~/.zshrc
```

That's it.

## Customization

The cat can be changed with `PAWSH_FACE`:

```zsh
PAWSH_FACE='ᓚᘏᗢ'
```

The default is:

```text
>ﻌ<
```

Colors use ZSH's named ANSI colors, so they follow your terminal's color palette.

## Requirements

* ZSH 5.3+
* Git
* A terminal with Unicode support

No framework is required.

No Oh My Zsh.

No plugin manager.

No prompt engine.

Just ZSH.

## License

MIT

