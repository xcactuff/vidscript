# vidscript

Turn a narration script into timed scenes, subtitles and a shot list. One file in, everything you need to plan and caption a video out — no dependencies, no API keys, no account.

Built for faceless YouTube channels, where the script exists long before the video does and the tedious part is working out how long it runs, where the captions break, and which b-roll goes where.

![The vidscript window](docs/screenshot.png)

## What you get

From a single script file:

- **`.srt` subtitles** (and `.vtt` on request), broken at sentence and clause boundaries instead of mid-phrase
- **A shot list** as Markdown and CSV — every scene with its timecode, duration, word count and visual directions
- **A runtime estimate** before you record anything
- **`.json`** with the whole storyboard, for feeding into your own tooling
- **One text file per scene**, optionally, so you can render narration in chunks rather than pasting a whole script into a voice tool and losing control of the pacing

## Two ways to run it

**A window.** Double-click `vidscript.bat` on Windows or `vidscript.command` on macOS. It sets itself up the first time, then opens. Pick a script, press Generate.

**A terminal.**

```console
$ vidscript examples/present-bias.md --tts

present-bias: 4 scenes · 147 words · 01:01 at 150 wpm

   1. 00:00   14.0s  Hook
   2. 00:15   24.0s  The present bias
   3. 00:39   12.5s  The boring solution
   4. 00:52    8.8s  Close
```

## Install

Python 3.9 or newer.

```bash
git clone https://github.com/xcactuff/vidscript.git
cd vidscript
pip install .
```

To build a standalone app with its own icon — one file, no Python needed — double-click `build-exe.bat` (Windows) or `build-app.command` (macOS). Pushing a tag builds both on GitHub instead and attaches them to a release.

## Writing a script

Plain text works. Markdown works better. Nothing is mandatory.

A `##` heading starts a scene and names it. A `---` rule starts one too. If the script has neither, blank lines separate scenes, so a file you already wrote will work untouched. A `#` heading at the top is the video's title, not a scene.

Anything in labelled square brackets — `[B-ROLL: drone shot of the city]`, `[TITLE CARD: logo]` — is pulled out of the narration and filed as a visual direction, so it reaches the shot list but never the subtitles. A line in plain parentheses does the same.

```markdown
# Why your brain loses you money

## Hook

[B-ROLL: banknotes falling in slow motion]
Two people earn exactly the same salary. Ten years later, one owns a
house outright and the other is juggling three maxed-out credit cards.

## The present bias

(simple chart: perceived value against time)
Your brain was built to survive today, not to retire in thirty years.
```

## Options

| Flag | What it does |
| --- | --- |
| `-o`, `--outdir` | Where generated files go (default `build`) |
| `-l`, `--lang` | Narration language, which picks a default speaking rate: `en` 150, `es` 165, `pt` 160, `fr` 160, `de` 140, `it` 165 wpm |
| `--wpm` | Set the speaking rate directly, overriding `--lang` |
| `--gap` | Pause between scenes, in seconds (default 0.6) |
| `--max-chars` | Characters per subtitle line (default 42) |
| `--max-lines` | Lines per subtitle cue (default 2) |
| `--vtt` | Also write WebVTT |
| `--tts` | Write one narration file per scene |
| `--dry-run` | Print the summary, write nothing |

The window is translated into the same six languages and follows the narration language you pick.

## How the timing works

Duration is estimated from word count at the chosen words-per-minute rate, so it's a planning number rather than a measurement of real audio. Calibrate it once and it lands within a few seconds per minute: take a video you've published, divide its script's word count by the runtime in minutes, and pass that as `--wpm` from then on.

Subtitle cues are spread across each scene in proportion to their length, clamped between 1 and 7 seconds, and broken at sentence boundaries first, clause boundaries second, and word boundaries only as a last resort.

## As a library

```python
from vidscript import parse_script, build_storyboard
from vidscript.subtitles import to_srt

board = build_storyboard(parse_script(open("script.md").read()), wpm=165)

print(board.duration, len(board.cues))
open("out.srt", "w").write(to_srt(board.cues))
```

## Development

```bash
pip install -e ".[dev]"
pytest
```

Full walkthrough for non-technical users: [MANUAL.md](MANUAL.md).

## License

MIT — see [LICENSE](LICENSE).
