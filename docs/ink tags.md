# Ink tags

Put tags on a line after the text. Several tags can sit on the same line.

```ink
Hello. # anim:wave # window:speech_left # skippable:false
```

Keys are case-insensitive. Bool values: `true` / `false`, `1` / `0`, `yes` / `no`, `on` / `off`. A tag with no value counts as `true`.

## Line tags

| Tag | Example | What it does |
|---|---|---|
| `anim` | `# anim:scared` | Play this animation on the current character. If that character has a `pose`, the clip is `pose_anim` (`stand` + `scared` plays `stand_scared`). If the value is the pose itself (`# pose:close # anim:close`), the clip is that pose. With no pose, the value is the whole clip name. With no current character, the tag warns and does nothing. |
| `pose` | `# pose:stand` | Sticks for the current character until another `pose` for that character. An empty `# pose:` clears it. Does not play an animation by itself. |
| `char` | `# char:engineer` | This line only. Speak and animate as this character. The name matches `character_name` on the scene character. |
| `char_default` | `# char_default:engineer` | Sets the character for this line and every line after, until another `char_default`. A per-line `char` still overrides it. New stories start with no character. |
| `window` | `# window:speech_left` | Open this dialog window. It stays until another `window` tag. An unknown name uses `default`. |
| `instant` | `# instant` | This line only. Show the whole line at once. Without it, the line uses the window's printing speed. |
| `response` | `# response` | Show this line in the `player_phrase` window. The following lines stay on the window `# window` last selected. |
| `timeout` | `# timeout:7` | Start a timer (seconds) when visible choices appear. Time-out picks the first one. `# timeout:0` clears the timer. |
| `skippable` | `# skippable:false` | This line only. If `true` (the default), a click fills the rest of the line, then another click continues. If `false`, a click does nothing: after the line finishes, the story continues on its own. The wait is `response_continue_delay` on DialogController. A line that still has choices, or a line with `react_wait`, waits instead. |
| `skip_default` | `# skip_default:false` | Sets skippable for this line and every line after, until another `skip_default`. A per-line `skippable` still overrides it. New stories start with skippable on. |
| `react` | `# react:unequip:gun:gun_down` | This line only. When that inventory event or `action` happens, jump to the knot. Replaces the sticky set for this line. `# react:` means this line reacts to nothing. |
| `react_default` | `# react_default:action:shoot:gun_kill` | Same reaction for this line and every line after, until another `react_default`. A per-line `react` still replaces it. `# react_default:` clears it. A new story starts with none. |
| `react_wait` | `# react_wait` | This line only. The line stays up until a reaction fires or the player picks a visible option. Click, space-hold, and the auto-continue delay do not advance it. |

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

## Line reactions

`react` and `react_default` name an inventory event or an `action`, plus a knot path: `event:item:knot` or `action:name:knot`. Several reactions can share a line, or sit in one tag separated by commas. Item names match inventory ids in lowercase (`gun`, `photo`, `rag`).

- `pickup` — item added to inventory
- `equip` — item equipped
- `equip_start` — player started hold-to-equip
- `unequip` — item unequipped
- `unequip_start` — player started hold-to-unequip
- `action` — the equipped item's action, such as `shoot` or `drink`

```ink
Прошу вас... # react_default:unequip:gun:gun_down, action:shoot:gun_kill # react_wait # skippable:false
```

The jump keeps the current tunnel, so `->->` in the target knot still returns to the caller. Put side effects in that knot (`~ gun_drawn = false`).

`react_default` applies to the line that sets it. To keep reactions on a spoken line and drop them before the story continues, clear them on the next tag-only line:

```ink
Прошу вас, не делайте так больше. # skippable:false
# react_default:
->->
```

`react_wait` is for a line that has no visible option and should not move on by itself. A spoken line without it keeps playing, and a reaction can still interrupt it while it is up.

## Inline (not a tag)

`%%` in the line text shows visible options when the typewriter reaches that point. It is stripped from the displayed string. Without `%%`, options appear after the line finishes printing.

```ink
I wouldn't do that if I were you.%% Especially not with salt.
```
