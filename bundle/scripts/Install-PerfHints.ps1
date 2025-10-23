param([string]$RepoRoot=".")
$ErrorActionPreference="Stop"

$files = @(
  Join-Path $RepoRoot 'plane-app\index.html',
  Join-Path $RepoRoot 'plane-app\preview\index.html',
  Join-Path $RepoRoot 'index.html'
) | Where-Object { Test-Path $_ }

if (-not $files){ Write-Host "ℹ️ No HTML files found."; exit 0 }

$pre = @"
<link rel=""preconnect"" href=""https://fonts.gstatic.com"" crossorigin />
<link rel=""preconnect"" href=""https://fonts.googleapis.com"" />
"@

foreach($f in $files){
  $html = Get-Content $f -Raw

  if ($html -match '(?is)</head>' -and $html -notmatch 'fonts\.gstatic\.com'){
    $html = [regex]::Replace($html,'(?is)(</head>)',"$pre`r`n`$1",[System.Text.RegularExpressions.RegexOptions]::Singleline)
  }

  # If no <style>, add one with a safe note; otherwise skip (avoid bad -replace concat)
  if ($html -notmatch '(?is)<style[^>]*>'){
    $html = [regex]::Replace($html,'(?is)(</head>)',"<style>/* prefer fast text paint; set font-display:swap on @font-face if using webfonts */</style>`r`n`$1",[System.Text.RegularExpressions.RegexOptions]::Singleline)
  }

  Set-Content -Encoding utf8 -NoNewline $f -Value $html
}
Write-Host "✅ Perf: preconnects added; safe paint note injected (if no <style> existed)"
