param(
  [string]$RepoRoot=".",
  [string[]]$HtmlFiles=@("plane-app\index.html","plane-app\preview\index.html","index.html")
)
$ErrorActionPreference="Stop"

foreach($rel in $HtmlFiles){
  $f = Join-Path $RepoRoot $rel
  if (!(Test-Path $f)) { continue }
  $html = Get-Content $f -Raw
  if ($html -match '(?is)<nav[^>]*>' -and $html -notmatch '/coevolution/'){
    $html = [regex]::Replace($html,'(?is)(<nav[^>]*>)','$1<a href="/coevolution/" style="margin-left:8px">CoEvolution</a>',[System.Text.RegularExpressions.RegexOptions]::Singleline)
    Set-Content -Encoding utf8 -NoNewline $f -Value $html
  }
}
Write-Host "✅ Nav: /coevolution/ link ensured where possible"
