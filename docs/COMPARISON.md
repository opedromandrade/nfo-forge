# ffprobe vs mp3guessenc — Comparison Guide

Choosing the right engine depends on what you value most. Both produce identical `.nfo` structures, so switching between them won't break downstream tooling.

## 📊 Feature breakdown

| Feature                    | ffprobe         | mp3guessenc         |
|----------------------------|-----------------|---------------------|
| Execution speed            | ~10–50 ms/track | ~100–300 ms/track   |
| Dependency size            | ~30 MB          | ~1 MB               |
| ID3v1/v2 tag parsing       | ✅              | ✅                  |
| Bitrate per track          | ✅              | ✅                  |
| Sample rate / channels     | ✅              | ✅                  |
| LAME encoder tag           | ❌              | ✅                  |
| Variable bitrate detection | Partial         | Full                |
| Offline operation          | ✅ (after setup)| ✅                  |
| Batch folder scanning      | ✅              | ✅                  |

## 🏃 When to use ffprobe

- You already have FFmpeg installed (common for media workflows).
- Speed matters: processing hundreds of albums quickly.
- You just need ID3 metadata + basic stream info.
- You want minimal dependency footprint.

## 🔍 When to use mp3guessenc

- You're doing forensic analysis (e.g., distinguishing rips vs. transcodes).
- LAME/VBR header inspection matters (audible quality differences).
- You want frame-level accuracy over raw speed.
- You trust SourceForge's niche tools over the FFmpeg ecosystem.

## 📈 Real-world example

Suppose you're archiving a CD collection and need to flag re-encoded MP3s (e.g., 128→192 kbps). mp3guessenc exposes the LAME header and original source bitrate — ffprobe won't see past the current container tags.

If you're just organizing files for a media server (Plex, Jellyfin), ffprobe gives you all the display data you need in a fraction of the time.

## 🔄 Switching variants

Both scripts accept the same arguments and write `.nfo` files in identical format. Swap the folder (`ffprobe/` ↔ `mp3guessenc/`) — nothing else needs changing.

## ⚠️ Known edge cases

- **Corrupted ID3 tags**: both may fail silently on malformed files. Manually inspect with a dedicated tag editor.
- **Non-MP3 files**: neither variant handles FLAC, ALAC, or Opus. Stick to `.mp3`.
- **Unicode metadata**: test your locale before batch processing (both claim UTF‑8, but Windows shells vary).

---

TL;DR: ffprobe = throughput, mp3guessenc = insight. 🎯