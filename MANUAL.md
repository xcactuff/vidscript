# vidscript — user manual

This is the long version. If you just want the flags, the [README](README.md) has them in a table.

This manual assumes you have never run a Python program before. If you have, skip to [Your first run](#your-first-run).

---

## 1. What this tool is for

You write a script. You want to know how long the video will be, where the subtitles break, and which b-roll goes in which part — **before** you record anything.

vidscript reads your script file and gives you back:

| File | What it's for |
| --- | --- |
| `yourscript.srt` | Subtitles. Upload straight to YouTube. |
| `yourscript.vtt` | Same subtitles in the format most web players want (optional). |
| `yourscript.shotlist.md` | A readable plan: every scene with its timecode, length and visuals. |
| `yourscript.shotlist.csv` | The same plan, openable in Excel or Google Sheets. |
| `yourscript.json` | Everything, in a format other programs can read. |
| `yourscript-tts/scene-01.txt` … | One file per scene, for pasting into a voice generator (optional). |

It does not record audio, edit video, or connect to the internet. It reads one text file and writes a handful of text files. That's the whole job.

---

## 2. Installing it

### Step 1 — check you have Python

Open a terminal (**Terminal** on Mac, **PowerShell** on Windows) and type:

```bash
python3 --version
```

If you see something like `Python 3.11.5`, you're set. On Windows you may need `python --version` instead.

If you get an error, install Python from [python.org/downloads](https://www.python.org/downloads/). On Windows, tick **"Add Python to PATH"** on the first screen of the installer — this is the step everyone skips and then wonders why nothing works.

### Step 2 — get vidscript

```bash
git clone https://github.com/xcactuff/vidscript.git
cd vidscript
pip install .
```

Those are three separate commands — run them one at a time, waiting for each to finish. On Windows use `py -m pip install .` for the last one.

No git? Click the green **Code** button on the GitHub page, choose **Download ZIP**, unzip it, then open a terminal in that folder and run `pip install .`.

### Step 3 — check it worked

```bash
vidscript --version
```

You should see `vidscript 0.1.0`.

> **If the terminal says `vidscript: command not found`, or on Windows `'vidscript' is not recognized as an internal or external command`** — the install worked, your system just doesn't know where to find the shortcut. Use the long form everywhere this manual says `vidscript`: `python3 -m vidscript.cli` on Mac and Linux, `py -m vidscript.cli` on Windows. Everything else is identical.

> **Windows note.** Throughout this manual, wherever you see `python3`, type `py` instead (or `python` if `py` isn't recognised). Paths use backslashes and are safest in quotes: `py -m vidscript.cli "C:\Users\You\Desktop\my-script.md"`.

---

## 2b. The version with buttons (no terminal)

Everything above is the terminal version. If you'd rather click, there's a window.

**Easiest way.** In the `vidscript` folder, double-click `vidscript.bat` (Windows) or `vidscript.command` (Mac). The first time, it installs what it needs and then opens the window; after that it just opens. If Windows warns you about running it, choose **More info → Run anyway** — that warning appears for any unsigned file, including your own.

**The window.** Press *Choose…* next to "Script file" and pick your script. The interface follows the narration language you choose, and starts in your system's language when it has a translation. Set the language — it fills in a speaking rate for you, which you can overwrite. Tick the extras you want. Press **Generate**. The results land in a `vidscript` folder next to your script, and *Open results folder* takes you there.

You can also drag a script onto the app, or right-click it and choose "Open with", and it opens already loaded.

**Turning it into a real .exe.** Double-click `build-exe.bat` (Windows) or `build-app.command` (Mac). It downloads the build tools, compiles, and drops a single file in `dist/` — icon and all. That file is the whole program: drag it wherever you like, hand it to someone else, and it runs without Python installed. Windows will warn about an unrecognised app the first time; that happens to any unsigned binary.

**Or let GitHub build it.** Useful when you want downloadable files on your releases page:

```bash
git tag v0.1.0
git push --tags
```

Go to the **Actions** tab on your repo, wait for the build to go green, and the files are attached to the new release on the **Releases** page. Anyone can download and run them. You can also start a build by hand from the Actions tab without tagging.

---

## 3. Your first run

There's an example script in the repo. Try it:

```bash
vidscript examples/present-bias.md
```

You'll see:

```
present-bias: 4 scenes · 147 words · 01:01 at 150 wpm

   1. 00:00   14.0s  Hook
   2. 00:15   24.0s  The present bias
   3. 00:39   12.5s  The boring solution
   4. 00:52    8.8s  Close

  wrote build/present-bias.srt
  wrote build/present-bias.shotlist.csv
  wrote build/present-bias.shotlist.md
  wrote build/present-bias.json
```

The files are in a new folder called `build`. Open `build/present-bias.shotlist.md` in any text editor and you'll see the plan for the video.

Now do it with your own script:

```bash
vidscript path/to/my-script.md -l es
```

On Windows, paths use backslashes and often need quotes: `vidscript "C:\Users\You\Desktop\my-script.md"`.

---

## 4. How to write a script vidscript understands

Any `.txt` or `.md` file works. Nothing is mandatory — a plain wall of text will still produce subtitles. The conventions below just give you more control.

### Scenes

A scene is one beat of the video: the hook, a point you're making, the outro. vidscript needs to know where one ends and the next starts. You have three ways to tell it, and it picks whichever you used:

**With `##` headings** (recommended — your scenes get names):

```markdown
## Hook
Two people earn exactly the same...

## The present bias
Your brain was built to survive today...
```

**With `---` separators:**

```markdown
Two people earn exactly the same...

---

Your brain was built to survive today...
```

**With nothing** — if your script has no headings and no `---`, then a blank line starts a new scene. This means a plain text file you already wrote will work without editing.

A `#` heading at the very top (one `#`, not two) is treated as the video's title and ignored. Put your title there if you like.

### Visual directions

Anything in square brackets with a label becomes a note on the shot list and is **removed from the narration**, so it never ends up in your subtitles:

```markdown
[B-ROLL: drone shot over the city at night]
[TITLE CARD: channel logo]
[GRAPHIC: chart of savings over 10 years]
```

The label can be anything you want — `[MUSIC: build]`, `[CUT TO: closeup]`, `[NOTA: recordar mencionar el link]`. vidscript doesn't care what you call it; it just files it under that scene.

A line in plain parentheses does the same thing:

```markdown
(show the chart here)
```

Use brackets when you want a labelled category, parentheses for a quick note.

### A complete example

```markdown
# Why your brain loses you money

## Hook

[B-ROLL: banknotes falling in slow motion]
Two people earn exactly the same. Ten years later, one owns a house
and the other owns three maxed-out cards. The difference isn't the
salary. It's what's between their ears.

## The present bias

[B-ROLL: hourglass on a wooden table]
Your brain was built to survive today, not to retire in thirty years.

(simple chart: perceived value vs time)
That's why a thousand now feels more real than five thousand later.

## Close

If this helped, the next video breaks down how much you should
actually have saved by your age. See you there.
```

---

## 5. The options, explained

### Where files go — `-o`

By default everything lands in a folder called `build` next to wherever you ran the command. Change it:

```bash
vidscript my-script.md -o ~/Videos/episode-14
```

### Language and speed — `-l` and `--wpm`

This is the setting that matters most, because everything else is calculated from it.

`-l` picks a sensible speaking rate for the language:

| Code | Language | Words per minute |
| --- | --- | --- |
| `en` | English | 150 |
| `es` | Spanish | 165 |
| `pt` | Portuguese | 160 |
| `fr` | French | 160 |
| `de` | German | 140 |
| `it` | Italian | 165 |

```bash
vidscript my-script.md -l es
```

These are starting points for a calm, explainer-style delivery. **Your real pace is almost certainly different**, and once you know it you should use it:

1. Take a video you already published.
2. Count the words in its script (any word counter will do).
3. Divide by the runtime in minutes.
4. That's your number.

So if a 1,400-word script became a 7:45 video, that's 1400 ÷ 7.75 ≈ **181 wpm**. From then on:

```bash
vidscript my-script.md --wpm 181
```

Do this once and every estimate afterwards will be accurate to a few seconds. `--wpm` overrides `-l`, so you don't need both.

### Pause between scenes — `--gap`

How much silence sits between one scene and the next, in seconds. Default is `0.6`. If you cut tight, use `--gap 0.2`. If you leave the last word hanging before each transition, try `--gap 1.2`.

### Subtitle shape — `--max-chars` and `--max-lines`

Defaults are 42 characters across, 2 lines deep — the standard that reads comfortably on a phone. Shorts and vertical video usually want narrower:

```bash
vidscript my-short.md --max-chars 28 --max-lines 2
```

One line only (common for big animated captions):

```bash
vidscript my-script.md --max-lines 1 --max-chars 32
```

### Extra outputs — `--vtt` and `--tts`

`--vtt` writes a second subtitle file in WebVTT format. You need it if the video goes on your own website rather than YouTube.

`--tts` writes one text file per scene into a `yourscript-tts/` folder. Instead of pasting a 1,500-word script into a voice generator and accepting whatever pacing comes out, you render scene by scene — which means you can redo scene 3 without touching the rest, and you get natural breathing room at every cut.

### Checking before committing — `--dry-run`

Prints the summary and writes nothing. Useful while you're still trimming the script:

```bash
vidscript my-script.md -l es --dry-run
```

If it says 11 minutes and you wanted 8, cut 3 minutes' worth of words and run it again. No files, no cleanup.

---

## 6. A real workflow

Here's how this fits into making a video, start to finish.

**While writing.** Run with `--dry-run` every time you finish a draft. You're watching two things: total runtime, and whether any single scene has gone long. A scene over about 45 seconds usually means two ideas got stuck together and should be split.

**When the script is locked.** Run it for real with `--tts`:

```bash
vidscript episode-14.md -l es --wpm 181 --tts -o ~/Videos/ep14
```

**Recording.** Open `ep14/episode-14-tts/` and feed the scenes one at a time into your voice tool, saving each as its own audio file. Now you have narration that matches your scene structure exactly, so dropping it on the timeline is mechanical rather than fiddly.

**Editing.** Open `ep14/episode-14.shotlist.md` on a second screen. Every scene has its timecode and its b-roll notes in order — that's your edit plan. If you prefer a spreadsheet, open the `.csv` instead and add your own columns for footage links or status.

**Publishing.** Upload `ep14/episode-14.srt` to YouTube under Subtitles. If your recorded pace drifted from the estimate, re-run with the `--wpm` your actual video came out at and upload the new file — this takes five seconds and is far faster than nudging cues by hand.

---

## 7. When something goes wrong

**`command not found: vidscript`, or `'vidscript' is not recognized as an internal or external command`**
The install worked, your PATH just doesn't include the shortcut. Use `python3 -m vidscript.cli` (Mac, Linux) or `py -m vidscript.cli` (Windows) instead of `vidscript` — same arguments, same result.

**`no such option: -l` right after `pip install`**
Two commands got typed as one. `pip install .` is the install and runs once on its own; `vidscript my-script.md -l es` is the program. The `-l` belongs only to the second one.

**`cannot read my-script.md: No such file or directory`**
The path is wrong. Easiest fix: drag the script file from your file manager into the terminal window — it pastes the correct full path.

**`no narration found in the script`**
The file is empty, or everything in it is inside brackets or parentheses, which vidscript treats as directions rather than words to speak.

**The whole script came out as one scene.**
Your scenes aren't separated in a way it recognises. Add `##` headings, or `---` between scenes.

**A scene is missing from the output.**
Check it has actual narration. A scene with nothing but `[B-ROLL: ...]` still appears on the shot list, but with no subtitles, since there's nothing to say.

**The estimated runtime is way off.**
You're using a default speaking rate. Calculate your real one (section 5) and pass `--wpm`.

**Subtitles feel rushed or laggy in places.**
Timing is spread proportionally across each scene, so a scene where you deliberately slow down will drift. Splitting that scene into two — so it gets its own time budget — fixes it. Cues are never shorter than 1 second or longer than 7, whatever the maths says.

**Accented characters look wrong.**
Save your script as UTF-8. Every modern editor does this by default; Windows Notepad sometimes doesn't, and there's a dropdown in its Save As dialog for it.

---

## 8. Using it from Python

If you want to build something on top of it:

```python
from vidscript import parse_script, build_storyboard
from vidscript.subtitles import to_srt
from vidscript.shotlist import to_markdown

text = open("script.md", encoding="utf-8").read()
board = build_storyboard(parse_script(text), wpm=181)

print(f"{board.duration:.0f} seconds, {len(board.scenes)} scenes")

for scene in board.scenes:
    print(scene.index, scene.title, scene.directions)

open("out.srt", "w", encoding="utf-8").write(to_srt(board.cues))
open("plan.md", "w", encoding="utf-8").write(to_markdown(board))
```

`parse_script` gives you a list of `Scene` objects. `build_storyboard` fills in their `start` and `duration` and produces the subtitle `cues`. The exporters in `vidscript.subtitles` and `vidscript.shotlist` all take one of those and return a string — nothing writes to disk except the CLI.

---

## 9. Questions

**Does it need the internet or an API key?**
No. It has no dependencies beyond Python itself and never makes a network request.

**Does it work with languages other than the six listed?**
Yes — any language works, the list only controls the default speed. For anything else, pass `--wpm` yourself.

**Can it read a Word document or a Google Doc?**
Not directly. Export or copy-paste into a `.txt` or `.md` file first.

**Will the timings match my real video exactly?**
No. They're estimates from word count, typically within a few seconds per minute once your `--wpm` is calibrated. Good enough to plan and edit against; re-run after recording if you want the SRT to be exact.

**Can I run it on a whole folder of scripts?**
One file per run, but your shell will loop:

```bash
for f in scripts/*.md; do vidscript "$f" -l es --wpm 181 -o build; done
```

**How do I update to a newer version?**

```bash
cd vidscript
git pull
pip install .
```

---

Found a bug or want a feature? Open an issue at [github.com/xcactuff/vidscript/issues](https://github.com/xcactuff/vidscript/issues).
