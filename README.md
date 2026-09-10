# 🎵 album-nfo-generator

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