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
#PS#function Parse-Mp3GuessEncOutput([string]$Output) {
#PS#    $props = @{ 
#PS#        Artist = ""; Album = ""; Title = ""; Year = ""; Genre = ""; 
#PS#        DurationSec = 0; Bitrate = 0; SampleRate = 0; Channels = ""; Encoder = ""; RawOutput = ""
#PS#    }
#PS#    $props.RawOutput = $Output
#PS#
#PS#    $lines = $Output -split "`n"
#PS#    foreach ($line in $lines) {
#PS#        $line = $line.Trim()
#PS#        
#PS#        # ID3v1 Tags
#PS#        if ($line -match "^Title\s*:\s*(.*)") { $props.Title = $matches[1].Trim() }
#PS#        if ($line -match "^Artist\s*:\s*(.*)") { $props.Artist = $matches[1].Trim() }
#PS#        if ($line -match "^Album\s*:\s*(.*)") { $props.Album = $matches[1].Trim() }
#PS#        if ($line -match "^Year\s*:\s*(.*)") { $props.Year = $matches[1].Trim() }
#PS#        if ($line -match "^Genre\s*:\s*(.*)") { $props.Genre = $matches[1].Trim() }
#PS#        
#PS#        # Technical Data
#PS#        if ($line -match "^Audio frequency\s*:\s*(\d+)\s*Hz") { $props.SampleRate = $matches[1] }
#PS#        if ($line -match "^Encoding mode\s*:\s*(.*)") { $props.Channels = $matches[1].Trim() }
#PS#        if ($line -match "Length\s*:\s*(\d):(\d{2}):(\d{2})") {
#PS#            $h = [int]$matches[1]
#PS#            $m = [int]$matches[2]
#PS#            $s = [int]$matches[3]
#PS#            $props.DurationSec = $h * 3600 + $m * 60 + $s
#PS#        }
#PS#        if ($line -match "^Data rate\s*:\s*(\d+(?:\.\d+)?)\s*kbps") {
#PS#            $props.Bitrate = [double]$matches[1]
#PS#        }
#PS#        if ($line -match "^Lame short string\s*:\s*(.*)") { $props.Encoder = $matches[1].Trim() }
#PS#    }
#PS#
#PS#    return $props
#PS#}
#PS#
#PS#Write-Host ""
#PS#Write-Host "$(Get-Emoji 0x1F3B5) NFO Generator (Parsing mp3guessenc)" -ForegroundColor Magenta
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
#PS#    Write-Host "    This script needs mp3guessenc to read the encoder settings."
#PS#    Write-Host "    Place mp3guessenc.exe in this folder and try again."
#PS#    Write-Host ""
#PS#    Write-Host "$(Get-Emoji 0x1F6D1) Stopping." -ForegroundColor Red
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
#PS#Write-Host "$(Get-Emoji 0x1F3A7) Reading tags via mp3guessenc..."
#PS#
#PS#$sumBr = 0.0
#PS#$sumDur = 0.0
#PS#$sumSize = 0.0
#PS#$trackList = [System.Collections.Generic.List[string]]::new()
#PS#$trackNumber = 0
#PS#$jsonList = @()
#PS#$refTrackProps = $null
#PS#
#PS#foreach ($file in $files) {
#PS#    # Run mp3guessenc and capture output
#PS#    # Force ISO-8859-1 for mp3guessenc output (common for ID3v1), then convert to UTF-8
#PS#    $psi = New-Object System.Diagnostics.ProcessStartInfo
#PS#    $psi.FileName = $mgenc
#PS#    $psi.Arguments = "-- `"$($file.FullName)`""
#PS#    $psi.RedirectStandardOutput = $true
#PS#    $psi.RedirectStandardError = $true
#PS#    $psi.UseShellExecute = $false
#PS#    $psi.StandardOutputEncoding = [System.Text.Encoding]::GetEncoding("iso-8859-1")
#PS#    $psi.StandardErrorEncoding = [System.Text.Encoding]::GetEncoding("iso-8859-1")
#PS#    $proc = New-Object System.Diagnostics.Process
#PS#    $proc.StartInfo = $psi
#PS#    $proc.Start() | Out-Null
#PS#    $output = $proc.StandardOutput.ReadToEnd()
#PS#    $proc.WaitForExit()
#PS#    $proc.Close()
#PS#    
#PS#    if (-not $output) {
#PS#        Write-Warning "$(Get-Emoji 0x26A0) Could not read $($file.Name)"
#PS#        continue
#PS#    }
#PS#
#PS#    $props = Parse-Mp3GuessEncOutput ($output -join "`n")
#PS#    
#PS#    if ($null -eq $props) {
#PS#        Write-Warning "$(Get-Emoji 0x26A0) Could not parse $($file.Name)"
#PS#        continue
#PS#    }
#PS#
#PS#    $trackNumber++
#PS#    $jsonList += $props
#PS#
#PS#    $sumBr += $props.Bitrate
#PS#    $sumDur += $props.DurationSec
#PS#    $sumSize += $file.Length
#PS#
#PS#    $title = Value-Or-Unknown $props.Title
#PS#    if ($title -eq "Unknown") { $title = $file.BaseName }
#PS#
#PS#    $trackArtist = Value-Or-Unknown $props.Artist
#PS#
#PS#    # Format Track Time
#PS#    $ts = [TimeSpan]::FromSeconds($props.DurationSec)
#PS#    $trackTime = "{0:00}:{1:00}:{2:00}" -f [math]::Floor($ts.TotalHours), $ts.Minutes, $ts.Seconds
#PS#
#PS#    [void]$trackList.Add(("{0:00}.{1} - {2} [{3}]" -f $trackNumber, $trackArtist, $title, $trackTime))
#PS#
#PS#    # Reference track
#PS#    if ($null -eq $refTrackProps -and $props.Album -ne "Unknown") {
#PS#        $refTrackProps = $props
#PS#    }
#PS#}
#PS#
#PS#if ($trackNumber -eq 0) {
#PS#    Write-Host "$(Get-Emoji 0x274C) No readable MP3 files found."
#PS#    exit 1
#PS#}
#PS#
#PS#if ($null -eq $refTrackProps) { $refTrackProps = $jsonList[0] }
#PS#
#PS#Write-Host "$(Get-Emoji 0x1F50E) Picking album reference..."
#PS#
#PS#$artist   = Value-Or-Unknown $refTrackProps.Artist
#PS#$album    = Value-Or-Unknown $refTrackProps.Album
#PS#$year     = Value-Or-Unknown $refTrackProps.Year
#PS#$genre    = Value-Or-Unknown $refTrackProps.Genre
#PS#$label    = "Unknown"
#PS#$disc     = "Unknown"
#PS#
#PS#$rate     = $refTrackProps.SampleRate
#PS#$chan     = $refTrackProps.Channels
#PS#$codecStr = "MPEG Audio Layer 3"
#PS#
#PS#Write-Host "$(Get-Emoji 0x1F52C) Analyzing encoder info..."
#PS#
#PS#$encInfo = @{ lame = $refTrackProps.Encoder; brmode = ""; quality = "" }
#PS#
Determine encoding mode from raw output
#PS#$codecShort = "MP3"
#PS#if ($refTrackProps.RawOutput -match "VBR") { 
#PS#    $codecShort = "MP3 VBR" 
#PS#    if ($refTrackProps.RawOutput -match "-V\s?(\d)") {
#PS#        $codecShort = "$codecShort V$($matches[1])"
#PS#    }
#PS#} elseif ($refTrackProps.RawOutput -match "CBR") { 
#PS#    $codecShort = "MP3 CBR" 
#PS#}
#PS#
#PS#$encoderStr = $encInfo.lame
#PS#if (-not $encoderStr) { $encoderStr = "Unknown" }
#PS#
#PS#Write-Host "$(Get-Emoji 0x1F4DD) Composing the NFO..."
#PS#
#PS#$avgBr = [math]::Round($sumBr / $trackNumber)
#PS#$totalSize = [math]::Round($sumSize / 1MB, 2)
#PS#$timeSpan = [TimeSpan]::FromSeconds($sumDur)
#PS#$playtime = "{0:00}:{1:00}:{2:00}" -f [math]::Floor($timeSpan.TotalHours), $timeSpan.Minutes, $timeSpan.Seconds
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
#PS#$(Format-Field "Channels" $chan)
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