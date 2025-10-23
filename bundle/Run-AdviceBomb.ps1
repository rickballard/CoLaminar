param([string]$RepoRoot=".")
$ErrorActionPreference="Stop"
$base = Split-Path -Parent $MyInvocation.MyCommand.Path
& (Join-Path $base 'scripts\Install-CoEvolution.ps1') -RepoRoot $RepoRoot
& (Join-Path $base 'scripts\Install-Plane-UX.ps1')    -RepoRoot $RepoRoot
& (Join-Path $base 'scripts\Install-ExplainerGlossary.ps1') -RepoRoot $RepoRoot
Write-Host "🎉 Advice-bomb completed. Next: git add . && git commit -m 'Apply CoLaminar advice-bomb' && git push"
