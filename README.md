# Tmux CZ

A tmux theme inspired by CZ2128 Delta

![tmux statusline with tmux-cz](doc/tmux-cz2.png)

## Requirements

A Tmux enabled 256 colours and UTF-8 features.

Almost all Tmux probably fill the requirements, so we don't need to do extra something.

If a problem is happened, please try the following command to run Tmux or equivalent configurations to it.

```sh
tmux -2 -u
```

## Installation

### Installation with [Tmux Plugin Manager](https://github.com/tmux-plugins/tpm) (recommended)

1. Add plugin to the list of TPM plugins in `.tmux.conf`

    ```tmux
    set -g @plugin 'a5ob7r/tmux-cz'
    ```

1. Type `prefix + I` to fetch the plugin and source it.

### Manual Installation

1. Clone repository to local.

    ```sh
    git clone https://github.com/a5ob7r/tmux-cz.git ~/clone/path
    ```

1. Add this line to `~/.tmux.conf`

    ```tmux
    run-shell ~/clone/path/tmux-cz.tmux
    ```

1. Reload `~/.tmux.conf`

    ```sh
    tmux source-file ~/.tmux.conf
    ```

## Options

This theme provides some low-level options, which are not user-friendly and are probably hard for users to configure them.

Please see [Configurations](#Configurations) section at first instead of this section.

### Colours

#### @TMUX_CZ_STATUS_BACKGROUND_COLOUR

The colour of status line background.

The value must be one of valid colour values of Tmux.
See the "STYLES" section in `tmux(1)` for details.

By default,

```tmux
set -g @TMUX_CZ_STATUS_BACKGROUND_COLOUR default
```

### Status Line Decorations

#### @TMUX_CZ_STATUS_LEFT_DECORATION

By default,

```tmux
set -g @TMUX_CZ_STATUS_LEFT_DECORATION '█'
```

#### @TMUX_CZ_RIGHT_DECORATION

By default,

```tmux
set -g @TMUX_CZ_RIGHT_DECORATION '█'
```

#### @TMUX_CZ_LEFT_SEPARATOR

By default,

```tmux
set -g @TMUX_CZ_LEFT_SEPARATOR ''
```

#### @TMUX_CZ_RIGHT_SEPARATOR

By default,

```tmux
set -g @TMUX_CZ_RIGHT_SEPARATOR ''
```

#### @TMUX_CZ_LEFT_SUBSEPARATOR

By default,

```tmux
set -g @TMUX_CZ_LEFT_SUBSEPARATOR '|'
```

#### @TMUX_CZ_RIGHT_SUBSEPARATOR

By default,

```tmux
set -g @TMUX_CZ_RIGHT_SUBSEPARATOR '|'
```

### Status Line Elements

These options define elements for each status line components as a virtual array user option of Tmux.

Tmux doesn't support to define user options with an array type.
Instead, this theme treats a collection of plain user options as an array user option using a variable name format convention.
The format is `@PREFIX_NAME_INDEX`, a head of `@` is a prefix to define Tmux user options.
This theme treats `PREFIX_NAME` as a variable name of an array, and `INDEX` is an index of an array.
The order of elements of an array is the alphabetical order of `INDEX`s, which is depends on the output of the `show-options` sub-command of Tmux.
The valid `PREFIX` and valid `NAME`s are below, but this theme treats any character sequences without spaces (` `) as a valid `INDEX`.

- PREFIX
    - TMUX_CZ
- NAME
    - WINDOW_STATUS_MAIN_ELEMENT
    - WINDOW_STATUS_SUB_ELEMENT
    - WINDOW_STATUS_CURRENT_MAIN_ELEMENT
    - WINDOW_STATUS_CURRENT_SUB_ELEMENT
    - STATUS_LEFT_ELEMENT
    - STATUS_RIGHT_ELEMENT

If a variable name is `@TMUX_CZ_WINDOW_STATUS_MAIN_ELEMENT_0`, `PREFIX` is `TMUX_CZ`, `NAME` is `WINDOW_STATUS_MAIN_ELEMENT` and `INDEX` is `0`.

The special format `@PREFIX_NAME_` with any value, which is no `INDEX`, means the empty array.

#### @TMUX_CZ_WINDOW_STATUS_MAIN_ELEMENT_*

By default,

```tmux
set -g @TMUX_CZ_WINDOW_STATUS_MAIN_ELEMENT_0 ' #{window_name} '
```

#### @TMUX_CZ_WINDOW_STATUS_SUB_ELEMENT_*

By default,

```tmux
set -g @TMUX_CZ_WINDOW_STATUS_SUB_ELEMENT_0 ' #{window_index}#{window_flags} '
```

#### @TMUX_CZ_WINDOW_STATUS_CURRENT_MAIN_ELEMENT_*

By default,

```tmux
set -g @TMUX_CZ_WINDOW_STATUS_CURRENT_MAIN_ELEMENT_0 ' #{window_name} '
```

#### @TMUX_CZ_WINDOW_STATUS_CURRENT_SUB_ELEMENT_*

By default,

```tmux
set -g @TMUX_CZ_WINDOW_STATUS_CURRENT_SUB_ELEMENT_0 ' #{window_index}#{window_flags} '
```

#### @TMUX_CZ_STATUS_LEFT_ELEMENT_*

By default,

```tmux
set -g @TMUX_CZ_STATUS_LEFT_ELEMENT_0 TMUX_CZ_STATUS_LEFT_DECORATION
set -g @TMUX_CZ_STATUS_LEFT_ELEMENT_1 ' #H [#S] '
```

#### @TMUX_CZ_STATUS_RIGHT_ELEMENT_*

By default,

```tmux
set -g @TMUX_CZ_STATUS_RIGHT_ELEMENT_0 ' %H:%M '
set -g @TMUX_CZ_STATUS_RIGHT_ELEMENT_1 ' %Y-%m-%d(%a) '
set -g @TMUX_CZ_STATUS_RIGHT_ELEMENT_2 TMUX_CZ_RIGHT_DECORATION
```

## Configurations

This section provides some configuration examples.

### Decorations with Powerline Font

![tmux statusline with tmux-cz using powerline font](doc/tmux-cz3.png)

To decorate this theme with Powerline Font,

```tmux
set -g @TMUX_CZ_STATUS_LEFT_DECORATION 
set -g @TMUX_CZ_RIGHT_DECORATION 
set -g @TMUX_CZ_LEFT_SEPARATOR 
set -g @TMUX_CZ_RIGHT_SEPARATOR 
set -g @TMUX_CZ_LEFT_SUBSEPARATOR 
set -g @TMUX_CZ_RIGHT_SUBSEPARATOR 

# OR

set -g @TMUX_CZ_STATUS_LEFT_DECORATION ' '
set -g @TMUX_CZ_RIGHT_DECORATION ' '
set -g @TMUX_CZ_LEFT_SEPARATOR ' '
set -g @TMUX_CZ_RIGHT_SEPARATOR ' '
set -g @TMUX_CZ_LEFT_SUBSEPARATOR ' '
set -g @TMUX_CZ_RIGHT_SUBSEPARATOR ' '
```

### Add elements to status line components

To add ` foo ` to the status-left component,

```tmux
set -g @TMUX_CZ_STATUS_LEFT_ELEMENT_1 TMUX_CZ_STATUS_LEFT_DECORATION
set -g @TMUX_CZ_STATUS_LEFT_ELEMENT_2 ' #H [#S] '
set -g @TMUX_CZ_STATUS_LEFT_ELEMENT_3 ' foo '
```

Or add an element using [tmux-battery](https://github.com/tmux-plugins/tmux-battery),

```tmux
set -g @TMUX_CZ_STATUS_RIGHT_ELEMENT_0 ' #{battery_status_fg}#{battery_icon} #{battery_percentage} '
set -g @TMUX_CZ_STATUS_RIGHT_ELEMENT_1 ' %H:%M '
set -g @TMUX_CZ_STATUS_RIGHT_ELEMENT_2 ' %Y-%m-%d(%a) '
set -g @TMUX_CZ_STATUS_RIGHT_ELEMENT_3 TMUX_CZ_RIGHT_DECORATION
```

### Remove elements from status line components

To remove the host name element,

```tmux
set -g @TMUX_CZ_STATUS_LEFT_ELEMENT_0 TMUX_CZ_STATUS_LEFT_DECORATION
```

Or to remove the right decoration element,

```tmux
set -g @TMUX_CZ_STATUS_RIGHT_ELEMENT_0 ' %H:%M '
set -g @TMUX_CZ_STATUS_RIGHT_ELEMENT_1 ' %Y-%m-%d(%a) '
```

### Hide status line components

To hide each status line components completely,

```tmux
# To hide status-left.
set -g @TMUX_CZ_STATUS_LEFT_ELEMENT_ ''

# To hide a main area of window-status-format.
set -g @TMUX_CZ_WINDOW_STATUS_MAIN_ELEMENT_ ''
```
