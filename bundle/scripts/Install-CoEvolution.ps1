param([string]$RepoRoot=".")
$ErrorActionPreference="Stop"
$dst = Join-Path $RepoRoot "coevolution"
New-Item -ItemType Directory -Force $dst | Out-Null
Copy-Item -Force "$PSScriptRoot\..\coevolution\*" $dst -Recurse
$idx = Join-Path $RepoRoot "index.html"
if (Test-Path $idx) {
  $html = Get-Content $idx -Raw
  if ($html -match "(?is)<nav[^>]*>" -and $html -notmatch "/coevolution/") {
    $html = [regex]::Replace($html,'(?is)(<nav[^>]*>)','$1<a href="/coevolution/" style="margin-left:8px">CoEvolution</a>',[System.Text.RegularExpressions.RegexOptions]::Singleline)
    Set-Content -Encoding utf8 -NoNewline $idx -Value $html
  }
}
Write-Host "✅ CoEvolution page installed at $dst"
