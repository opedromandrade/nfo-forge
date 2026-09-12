@echo off
setlocal DisableDelayedExpansion

set "TEMP_PS1=%TEMP%\album_nfo_%RANDOM%.ps1"

for %%I in (.) do set "FOLDER_NAME=%%~nxI"

powershell -NoProfile -ExecutionPolicy Bypass -Command "$src = '%~f0'; $out = '%TEMP_PS1%'; $L = [System.Collections.Generic.List[string]]::new(); foreach ($ln in [System.IO.File]::ReadAllLines($src)) { if ($ln.StartsWith('#PS#')) { $L.Add($ln.Substring(4)) } }; [System.IO.File]::WriteAllLines($out, $L)"

if not exist "%TEMP_PS1%" (
    echo [!] Failed to create temporary script.
    pause
    exit /b 1
)

powershell -NoProfile -ExecutionPolicy Bypass -File "%TEMP_PS1%"
set "RESULT=%ERRORLEVEL%"

del "%TEMP_PS1%" >nul 2>&1

if "%RESULT%"=="0" (
    echo.
    echo Done! %FOLDER_NAME%.nfo created.
) else (
    echo.
    echo Failed to create %FOLDER_NAME%.nfo.
)

pause
exit /b 0

#PS#$OutputEncoding = [System.Text.Encoding]::UTF8
#PS#[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
#PS#
#PS#function Get-Emoji([int]$hex) {
#PS#    return [char]::ConvertFromUtf32($hex)
#PS#}
#PS#
#PS#function Center-Line {
#PS#    param([string]$Text, [int]$Width = 69)
#PS#    if ([string]::IsNullOrEmpty($Text) -or $Text.Length -ge $Width) { return $Text }
#PS#    $pad = [int](($Width - $Text.Length) / 2)
#PS#    return (" " * $pad) + $Text
#PS#}
#PS#
#PS#function Get-Tag {
#PS#    param($Object, [string[]]$Names)
#PS#    if ($null -eq $Object) { return $null }
#PS#    foreach ($prop in $Object.PSObject.Properties) {
#PS#        foreach ($name in $Names) {
#PS#            if ($prop.Name -ieq $name) {
#PS#                if (-not [string]::IsNullOrWhiteSpace([string]$prop.Value)) {
#PS#                    return [string]$prop.Value
#PS#                }
#PS#            }
#PS#        }
#PS#    }
#PS#    return $null
#PS#}
#PS#
#PS#function Value-Or-Unknown {
#PS#    param($Value)
#PS#    if ([string]::IsNullOrWhiteSpace([string]$Value)) { return "Unknown" }
#PS#    return [string]$Value
#PS#}
#PS#
#PS#function Format-Field {
#PS#    param([string]$Label, [string]$Value)
#PS#    if ([string]::IsNullOrWhiteSpace($Value)) { $Value = "Unknown" }
#PS#    return ($Label.PadRight(25, ".") + ": " + $Value)
#PS#}
#PS#
#PS#function Get-EncodeInfo([string]$Tool, [string]$Path) {
#PS#    $info = @{ lame = ""; quality = ""; brmode = "" }
#PS#    try {
#PS#        $out = & $Tool -- "$Path" 2>$null
#PS#        $txt = ($out | Out-String)
#PS#        $m = [regex]::Match($txt, "LAME\d+(\.\d+)*")
#PS#        if ($m.Success) { $info.lame = $m.Value }
#PS#        foreach ($line in $out) {
#PS#            if ($line -match ":") {
#PS#                $parts = $line -split ":", 2
#PS#                $lbl = $parts[0].Trim().ToLower()
#PS#                $val = $parts[1].Trim()
#PS#                if ($lbl -match "channel") { continue }
#PS#                if ($lbl -match "bitrate mode|bit rate mode") {
#PS#                    if (-not $info.brmode) { $info.brmode = $val }
#PS#                }
#PS#            }
#PS#        }
#PS#        if (-not $info.brmode) {
#PS#            if ($txt -match "(?i)ABR") { $info.brmode = "ABR" }
#PS#            elseif ($txt -match "(?i)VBR") { $info.brmode = "VBR" }
#PS#            elseif ($txt -match "(?i)CBR") { $info.brmode = "CBR" }
#PS#        }
#PS#        $pv = [regex]::Match($txt, "(?i)-V\s?(\d)")
#PS#        if ($pv.Success) { $info.quality = "V" + $pv.Groups[1].Value }
#PS#        else {
#PS#            $pq = [regex]::Match($txt, "(?i)quality.*?:\s*(\d+)")
#PS#            if ($pq.Success) { $info.quality = "V" + $pq.Groups[1].Value }
#PS#        }
#PS#    } catch {}
#PS#    return $info
#PS#}
#PS#
#PS#Write-Host ""
#PS#Write-Host "$(Get-Emoji 0x1F3B5) NFO Generator" -ForegroundColor Magenta
#PS#Write-Host "====================================="
#PS#Write-Host ""
#PS#
#PS#Write-Host "$(Get-Emoji 0x1F50E) Looking for mp3guessenc..."
#PS#$mgenc = $null
#PS#$found = Get-Command "mp3guessenc" -ErrorAction SilentlyContinue
#PS#if ($found) { $mgenc = "mp3guessenc" }
#PS#elseif (Test-Path ".\mp3guessenc.exe") { $mgenc = Join-Path (Get-Location) "mp3guessenc.exe" }
#PS#
#PS#if ($null -eq $mgenc) {
#PS#    Write-Host ""
#PS#    Write-Host "$(Get-Emoji 0x26A0)  WARNING: mp3guessenc was not found!" -ForegroundColor Yellow
#PS#    Write-Host ""
#PS#    Write-Host "    This script needs mp3guessenc to read the encoder settings"
#PS#    Write-Host "    (LAME version, VBR/CBR mode, quality preset) hidden inside"
#PS#    Write-Host "    your MP3 files. Without it, no NFO can be created."
#PS#    Write-Host ""
#PS#    Write-Host "    HOW TO FIX IT:" -ForegroundColor Cyan
#PS#    Write-Host "    1. Download mp3guessenc (free & open source) from its"
#PS#    Write-Host "       official SourceForge project page:"
#PS#    Write-Host "       https://sourceforge.net/projects/mp3guessenc/"
#PS#    Write-Host "    2. Unzip it and either:"
#PS#    Write-Host "       - drop mp3guessenc.exe into this folder, or"
#PS#    Write-Host "       - add its folder to your system PATH."
#PS#    Write-Host "    3. Run this script again."
#PS#    Write-Host ""
#PS#    Write-Host "$(Get-Emoji 0x1F6D1) The script will now stop. Nothing was created." -ForegroundColor Red
#PS#    Write-Host ""
#PS#    pause
#PS#    exit 1
#PS#}
#PS#Write-Host "$(Get-Emoji 0x2705) mp3guessenc found!"
#PS#Write-Host ""
#PS#
#PS#$folderName = (Get-Item -LiteralPath ".").Name
#PS#
#PS#Write-Host "$(Get-Emoji 0x1F4C2) Scanning '$folderName' for MP3 files..."
#PS#$files = @(Get-ChildItem -File -Filter "*.mp3" | Sort-Object Name)
#PS#
#PS#if ($files.Count -eq 0) {
#PS#    Write-Host "$(Get-Emoji 0x26A0) No MP3 files found."
#PS#    pause
#PS#    exit 1
#PS#}
#PS#
#PS#Write-Host "$(Get-Emoji 0x1F44C) Found $($files.Count) MP3 file(s)!"
#PS#Write-Host ""
#PS#
#PS#Write-Host "$(Get-Emoji 0x1F3A7) Reading tags from all tracks..."
#PS#
#PS#$sumBr = 0.0
#PS#$sumDur = 0.0
#PS#$sumSize = 0.0
#PS#$trackList = [System.Collections.Generic.List[string]]::new()
#PS#$trackNumber = 0
#PS#$jsonList = @()
#PS#
#PS#foreach ($file in $files) {
#PS#    $jsonText = & ffprobe -v error -show_format -show_streams -of json -- "$($file.FullName)" 2>$null
#PS#
#PS#    if (-not $jsonText) {
#PS#        Write-Warning "$(Get-Emoji 0x26A0) Could not read $($file.Name)"
#PS#        continue
#PS#    }
#PS#
#PS#    $json = $jsonText | ConvertFrom-Json
#PS#    $jsonList += $json
#PS#
#PS#    $trackNumber++
#PS#
#PS#    if ($json.format.bit_rate) {
#PS#        $sumBr += [double]$json.format.bit_rate
#PS#    }
#PS#
#PS#    if ($json.format.duration) {
#PS#        $sumDur += [double]$json.format.duration
#PS#    }
#PS#
#PS#    if ($json.format.size) {
#PS#        $sumSize += [double]$json.format.size
#PS#    }
#PS#
#PS#    $title = $json.format.tags.title
#PS#    if ([string]::IsNullOrWhiteSpace([string]$title)) {
#PS#        $title = $file.BaseName
#PS#    }
#PS#
#PS#    $trackArtist = Get-Tag $json.format.tags @("artist")
#PS#    if ([string]::IsNullOrWhiteSpace([string]$trackArtist)) {
#PS#        $trackArtist = "Unknown"
#PS#    }
#PS#
#PS#    $trackDur = [double]$json.format.duration
#PS#    $ts = [TimeSpan]::FromSeconds($trackDur)
#PS#    $trackTime = "{0:00}:{1:00}:{2:00}" -f [math]::Floor($ts.TotalHours), $ts.Minutes, $ts.Seconds
#PS#
#PS#    [void]$trackList.Add(("{0:00}.{1} - {2} [{3}]" -f $trackNumber, $trackArtist, $title, $trackTime))
#PS#}
#PS#
#PS#if ($trackNumber -eq 0 -or $jsonList.Count -eq 0) {
#PS#    Write-Host "$(Get-Emoji 0x274C) No readable MP3 files found."
#PS#    exit 1
#PS#}
#PS#
#PS#Write-Host "$(Get-Emoji 0x1F50E) Picking the album's reference track..."
#PS#
#PS#$bestJson = $null
#PS#foreach ($entry in $jsonList) {
#PS#    if ($null -ne $entry.format.tags -and $null -ne (Get-Tag $entry.format.tags @("album"))) {
#PS#        $bestJson = $entry
#PS#        break
#PS#    }
#PS#}
#PS#if ($null -eq $bestJson) { $bestJson = $jsonList[0] }
#PS#
#PS#$tags = $bestJson.format.tags
#PS#$stream = $bestJson.streams | Where-Object { $_.codec_type -eq "audio" } | Select-Object -First 1
#PS#
#PS#Write-Host "$(Get-Emoji 0x1F52C) Asking mp3guessenc about the encoder..."
#PS#
#PS#$artist   = Get-Tag $tags @("album_artist", "albumartist", "artist")
#PS#$album    = Get-Tag $tags @("album")
#PS#$year     = Get-Tag $tags @("date", "year", "original_date", "TYER", "TDRC")
#PS#$genre    = Get-Tag $tags @("genre")
#PS#$label    = Get-Tag $tags @("publisher", "label", "organization")
#PS#$disc     = Get-Tag $tags @("disc", "part_number")
#PS#
#PS#$rate     = Value-Or-Unknown $stream.sample_rate
#PS#$chan     = Value-Or-Unknown $stream.channels
#PS#$layout   = $stream.channel_layout
#PS#$codecStr = Value-Or-Unknown $stream.codec_long_name
#PS#
#PS#$encInfo = Get-EncodeInfo $mgenc $files[0].FullName
#PS#
#PS#$codecShort = "MP3"
#PS#if ($encInfo.brmode) { $codecShort = "MP3 $($encInfo.brmode)" }
#PS#if ($encInfo.brmode -ne "CBR" -and $encInfo.quality) { $codecShort = "$codecShort $($encInfo.quality)" }
#PS#
#PS#$encoderStr = $encInfo.lame
#PS#if (-not $encoderStr) {
#PS#    $tagEnc = Get-Tag $tags @("encoder", "tool", "writing_library")
#PS#    if ($tagEnc) { $encoderStr = $tagEnc }
#PS#}
#PS#
#PS#Write-Host "$(Get-Emoji 0x1F4DD) Composing the NFO..."
#PS#
#PS#$avgBr = [math]::Round($sumBr / $trackNumber / 1000)
#PS#$totalSize = [math]::Round($sumSize / 1MB, 2)
#PS#$timeSpan = [TimeSpan]::FromSeconds($sumDur)
#PS#$playtime = "{0:00}:{1:00}:{2:00}" -f [math]::Floor($timeSpan.TotalHours), $timeSpan.Minutes, $timeSpan.Seconds
#PS#
#PS#$channelStr = "$chan channels"
#PS#if ($layout) { $channelStr = "$chan channels ($layout)" }
#PS#
#PS#$divider = ("-" * 69)
#PS#$blankLine = (" " * 69)
#PS#
#PS#$header = @"
#PS#$divider
#PS#$(Center-Line "$artist - $album")
#PS#$divider
#PS#"@
#PS#
#PS#$tracklistHeader = @"
#PS#$divider
#PS#$(Center-Line "Tracklist")
#PS#$divider
#PS#"@
#PS#
#PS#$footer = @"
#PS#$blankLine
#PS#$divider
#PS#"@
#PS#
#PS#$trackListing = ($trackList -join "`r`n")
#PS#
#PS#$nfo = @"
#PS#$header
#PS#
#PS#$(Format-Field "Artist" $artist)
#PS#$(Format-Field "Album" $album)
#PS#$(Format-Field "Genre" $genre)
#PS#$(Format-Field "Year" $year)
#PS#$(Format-Field "Publisher" $label)
#PS#$(Format-Field "Disc" $disc)
#PS#
#PS#$(Format-Field "Encoder" $encoderStr)
#PS#$(Format-Field "Bitrate (Avg)" "$avgBr kbps")
#PS#$(Format-Field "Encoding settings" $codecShort)
#PS#$(Format-Field "Format" $codecStr)
#PS#$(Format-Field "Channels" $channelStr)
#PS#$(Format-Field "Sample rate" "$rate Hz")
#PS#
#PS#$(Format-Field "TOTAL SIZE" "$totalSize MB")
#PS#$(Format-Field "PLAYTIME" $playtime)
#PS#
#PS#$tracklistHeader
#PS#$trackListing
#PS#
#PS#$footer
#PS#"@
#PS#
#PS#$outPath = Join-Path (Get-Location) ($folderName + ".nfo")
#PS#
#PS#[System.IO.File]::WriteAllText(
#PS#    $outPath,
#PS#    $nfo,
#PS#    [System.Text.UTF8Encoding]::new($false)
#PS#)
#PS#
#PS#Write-Host ""
#PS#Write-Host "$(Get-Emoji 0x2705) $folderName.nfo created successfully!" -ForegroundColor Green
#PS#Write-Host "$(Get-Emoji 0x1F3B6) Enjoy the music!"