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
#PS#$folderName = (Get-Item -LiteralPath ".").Name
#PS#
#PS#$files = @(Get-ChildItem -File -Filter "*.mp3" | Sort-Object Name)
#PS#
#PS#if ($files.Count -eq 0) {
#PS#    Write-Host "$(Get-Emoji 0x26A0) No MP3 files found."
#PS#    exit 1
#PS#}
#PS#
#PS#Write-Host "$(Get-Emoji 0x1F3B5) Processing album data..."
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
#PS#$artist   = Get-Tag $tags @("album_artist", "albumartist", "artist")
#PS#$album    = Get-Tag $tags @("album")
#PS#$year     = Get-Tag $tags @("date", "year", "original_date", "TYER", "TDRC")
#PS#$genre    = Get-Tag $tags @("genre")
#PS#$label    = Get-Tag $tags @("publisher", "label", "organization")
#PS#$disc     = Get-Tag $tags @("disc", "part_number")
#PS#$encoder  = Get-Tag $tags @("encoder", "tool", "writing_library", "lame")
#PS#if (-not $encoder) { $encoder = Get-Tag $stream.tags @("encoder", "tool") }
#PS#
#PS#$rate     = Value-Or-Unknown $stream.sample_rate
#PS#$chan     = Value-Or-Unknown $stream.channels
#PS#$layout   = $stream.channel_layout
#PS#$codecStr = Value-Or-Unknown $stream.codec_long_name
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
#PS#$(Format-Field "Encoder" $encoder)
#PS#$(Format-Field "Bitrate (Avg)" "$avgBr kbps")
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
#PS#Write-Host "$(Get-Emoji 0x2705) $folderName.nfo created successfully!"