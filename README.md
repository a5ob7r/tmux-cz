# Tmux CZ
A tmux theme inspired CZ2128 Delta

![](doc/tmux-cz2.png)

## Requirements
To escape Unicode codepoint (optional)
- Tmux 3.0+

  or

- Bash 4.2+

## Installation
### Installation with [Tmux Plugin Manager](https://github.com/tmux-plugins/tpm) (recommended)
1. Add plugin to the list of TPM plugins in `.tmux.conf`
```tmux
set -g @plugin 'a5ob7r/tmux-cz'
```

2. Hit `prefix + I` to fetch the plugin and source it.

### Manual Installation
1. Clone repository to local.
```shell
$ git clone https://github.com/a5ob7r/tmux-cz.git ~/clone/path
```

2. Add this line to `~/.tmux.conf`
```tmux
run-shell ~/clone/path/tmux-cz.tmux
```

3. Reload `~/.tmux.conf`
```shell
tmux source-file ~/.tmux.conf
```

## Use Powerline Font
![](doc/tmux-cz3.png)
This plugin can use powerline font.
Please add bottom configures in your `.tmux.conf`.

```
set -g @TMUX_CZ_LEFT_DECORATION '\ue0b0'
set -g @TMUX_CZ_RIGHT_DECORATION '\ue0b2'

set -g @TMUX_CZ_LEFT_SEPARATOR '\ue0b0'
set -g @TMUX_CZ_LEFT_SUBSEPARATOR '\ue0b1'
set -g @TMUX_CZ_RIGHT_SEPARATOR '\ue0b2'
set -g @TMUX_CZ_RIGHT_SUBSEPARATOR '\ue0b3'
```

## Supporting tmux-battery
This theme supports [tmux-battery](https://github.com/tmux-plugins/tmux-battery).
Please list this theme plugin above tmux/battery, if you want to use it.
```tmux
...
set -g @plugin 'a5ob7r/tmux-cz'
...
set -g @plugin 'tmux-plugins/tmux-battery'
...
```

## License
MIT
