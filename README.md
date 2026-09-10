# 🎵 nfo-forge

Turn a folder of MP3s into a tidy `.nfo` file. Because your music deserves
better metadata documentation than a sticky note. 🎶

Two engines, one job:

| Script | Engine | Best for |
|---|---|---|
| [`ffprobe/`](./ffprobe) | FFprobe (FFmpeg) | 🏎️ Speed, batch jobs, already-installed everywhere |
| [`mp3guessenc/`](./mp3guessenc) | mp3guessenc | 🔬 Deep encoder/LAME tag forensics |

Same input, same output format — pick your poison. ⚖️

## ✨ What it does

Point it at an album folder, get a structured `.nfo` back:

- 📀 Album, artist, year, genre (from ID3 tags)
- 🎚️ Per-track bitrate, sample rate, channel mode
- 🧪 Encoder info (mp3guessenc variant digs deeper — LAME headers, presets)
- 📁 Consistent, diff-friendly output

## 🚀 Quick start (Windows)

### ⚙️ Prerequisites

Each variant needs exactly one external tool. The scripts check for it at
startup and point you here if it's missing — no silent failures. 🔔

**For the ffprobe variant — install FFmpeg** (which bundles `ffprobe`):

- 🥇 Easiest: run in PowerShell
  ```powershell
  winget install ffmpeg
  ```
  (Chocolatey/Scoop users: `choco install ffmpeg` or `scoop install ffmpeg`)
- 🖱️ Manual route: grab `ffmpeg-release-essentials.zip` from
  [gyan.dev/ffmpeg/builds](https://www.gyan.dev/ffmpeg/builds/)
  ([BtbN's builds on GitHub](https://github.com/btbn/ffmpeg-builds/releases)
  also work), extract it, and add its `bin` folder to your `PATH`.
- ✅ Verify: open a new Command Prompt and run `ffprobe -version`

**For the mp3guessenc variant — download mp3guessenc:**

- 📦 Grab the Windows build from
  [mp3guessenc.sourceforge.io](https://mp3guessenc.sourceforge.io)
  (ships as `mp3guessenc.exe` — drop it somewhere on your `PATH`, or next
  to the script if you prefer keeping things local).
- ✅ Verify: run `mp3guessenc` with no arguments; it should print usage info.

### ▶️ Running the scripts

Open **Command Prompt** or **PowerShell**, then:

```bat
:: ffprobe variant
ffprobe\make_nfo.bat C:\Music\SomeArtist\SomeAlbum

:: mp3guessenc variant
mp3guessenc\make_nfo.bat C:\Music\SomeArtist\SomeAlbum
```

The `.nfo` lands in the album folder. Rinse, repeat, enjoy the metadata
glow. 💫

> 💡 **Tip:** if you'd rather not touch `PATH`, put `ffprobe.exe` /
> `mp3guessenc.exe` in the same folder as the script — the scripts look
> there first.

## ⚖️ Which one should I use?

Short version: **ffprobe for speed, mp3guessenc for truth.**

| Criterion              | ffprobe         | mp3guessenc                       |
|------------------------|-----------------|-----------------------------------|
| Speed                  | 🟢 Fast         | 🟡 Slower                         |
| Install friction       | 🟢 winget-ready | 🟢 Ready-made Windows exe         |
| Tag depth              | 🟡 ID3 basics   | 🟢 Frame-level                    |
| Encoder fingerprinting | ❌              | ✅                                |

More detail in [`examples/`](./examples) and the comparison doc.

## 📦 Output example

See [`examples/`](./examples) for a full sample. TL;DR — tidy, greppable,
reproducible.

## 🤝 Contributing

PRs welcome. Keep it POSIX-ish— er, Windows-friendly, keep it tested, keep
it kind. 💜

🛠️ Fork → branch (`feat/whatever`) → PR.
✅ Test both variants on at least one real album before submitting.
🐛 Open issues with: Windows version, script version, ffprobe/mp3guessenc
version, command run.

## 📜 License

[MIT](./LICENSE) — do whatever, just don't blame us when your 128 kbps
rips get exposed.