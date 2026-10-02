# Ink tags

Put tags on a line after the text. Several tags can sit on the same line.

```ink
Hello. # anim:wave # window:speech_left # skippable:false
```

Keys are case-insensitive. Bool values: `true` / `false`, `1` / `0`, `yes` / `no`, `on` / `off`. A tag with no value counts as `true`.

## Line tags

| Tag | Example | What it does |
|---|---|---|
| `anim` | `# anim:wave` | Play this animation on the current character. With no current character, the tag warns and does nothing. |
| `char` | `# char:engineer` | This line only. Speak and animate as this character. The name matches `character_name` on the scene character. |
| `char_default` | `# char_default:engineer` | Sets the character for this line and every line after, until another `char_default`. A per-line `char` still overrides it. New stories start with no character. |
| `window` | `# window:speech_left` | Open this dialog window. It stays until another `window` tag. An unknown name uses `default`. |
| `instant` | `# instant` | This line only. Show the whole line at once. Without it, the line uses the window's printing speed. |
| `response` | `# response` | Show this line in the `player_phrase` window. The following lines stay on the window `# window` last selected. |
| `timeout` | `# timeout:7` | Start a timer (seconds) when visible choices appear. Time-out picks the first one. `# timeout:0` clears the timer. |
| `skippable` | `# skippable:false` | This line only. If `true` (the default), a click fills the rest of the line, then another click continues. If `false`, a click does nothing: after the line finishes, the story continues on its own. The wait is `response_continue_delay` on DialogController. A line that still has choices waits for a button or its timeout instead. |
| `skip_default` | `# skip_default:false` | Sets skippable for this line and every line after, until another `skip_default`. A per-line `skippable` still overrides it. New stories start with skippable on. |

### `window` values

Each `TextBoxWithOptions` under `DialogController` is one window. Its name is the `window_name` property, or the node name when that property is empty. The window named `default` is the fallback.

```ink
Кто здесь? # window:thought_left
Это всё ещё мысль.
Это я. # window:speech_self
Слышу тебя. # window:speech_left
И снова обычное окно. # window:default
```

Hyphens and spaces match the same window (`speech-left`, `speech left`). A name that is not in the scene opens `default`. `# window:default` returns to the fallback window.

`# window:default` selects the default window and keeps it until another `# window` tag. `# response` shows that line in `player_phrase` and does not change the window used after it. A line with both shows the response in `player_phrase` and remembers the `# window` value for the next line. Whether the line then waits for a click or continues on its own follows `skippable`.

```ink
* [Про мальчика.]
    Про мальчика. # response
    -> boy
* [Пока хватит.]
    Пока хватит. # response # instant
    -> closing
```

## Choice tags

A choice whose **text** is `pickup:item`, `equip:item`, `equip_start:item`, `unequip:item`, or `unequip_start:item` is hidden from the UI and fires when that inventory event happens.

The same tokens work as **tags** on a visible choice, so clicking the button and using the item are the same option:

```ink
+ [Wave back]
+ [pickup:bottle]
	You're grabbing the bottle while I'm talking?
+ [Take it] # pickup:bottle
```

Item names match inventory ids in lowercase (`bottle`, `salt`, `pepper`). Events:

- `pickup` — item added to inventory
- `equip` — item equipped
- `equip_start` — player started hold-to-equip in the inventory
- `unequip` — item unequipped
- `unequip_start` — player started hold-to-unequip in the inventory

These choices belong to the current beat (available once Ink has reached that choice list, including while the line is still typing). If there is no matching choice, the item does nothing to the dialog.

## Inline (not a tag)

`%%` in the line text shows visible options when the typewriter reaches that point. It is stripped from the displayed string. Without `%%`, options appear after the line finishes printing.

```ink
I wouldn't do that if I were you.%% Especially not with salt.
```
