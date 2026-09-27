# Ink tags

Put tags on a line after the text. Several tags can sit on the same line.

```ink
Hello. # anim:wave # pos:top_right # skippable:false
```

Keys are case-insensitive. Bool values: `true` / `false`, `1` / `0`, `yes` / `no`, `on` / `off`. A tag with no value counts as `true`.

## Line tags

| Tag | Example | What it does |
|---|---|---|
| `anim` | `# anim:wave` | Play this animation on the dialogue actor. If the tag is missing or empty, the actor falls back to its default (`idle`). |
| `pos` | `# pos:top_right` | Move the text box. |
| `timeout` | `# timeout:7` | Start a timer (seconds) when visible choices appear. Time-out picks the first one. `# timeout:0` clears the timer. |
| `skippable` | `# skippable:false` | This line only. If `true`, click fills the remaining typewriter text. Does not advance the story. |
| `skip_default` | `# skip_default:false` | Sets skippable for this line and every line after, until another `skip_default`. A per-line `skippable` still overrides it. New stories start with skippable on. |

### `pos` values

`top_left`, `top` / `top_center`, `top_right`, `left` / `center_left`, `center`, `right` / `center_right`, `bottom_left`, `bottom` / `bottom_center`, `bottom_right`.

Hyphens and spaces are fine (`top-right`, `top right`).

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
