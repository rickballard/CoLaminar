
# [PASTE IN POWERSHELL] — Seed the CoLaminar repo with plans and docs.
param(
  [string]$RepoDir = "$HOME\Documents\GitHub\CoLaminar",
  [string]$ZipPath = "$HOME\Downloads\CoLaminar_SeedPack_20250823.zip"
)
Set-StrictMode -Version Latest; $ErrorActionPreference='Stop'

if(!(Test-Path $ZipPath)){ throw "Zip not found: $ZipPath" }
if(!(Test-Path $RepoDir)){ throw "Repo dir not found: $RepoDir" }

$dest = Join-Path $RepoDir "__seed_tmp"
Expand-Archive -LiteralPath $ZipPath -DestinationPath $dest -Force

$Copy = "/E","/NFL","/NDL","/NJH","/NJS","/NC","/NS","/NP","/XO"
robocopy $dest $RepoDir * $Copy | Out-Null

Remove-Item $dest -Recurse -Force

# Optional: create labels
try {
  gh label create bug -c "#d73a4a" -d "Something is broken" 2>$null
  gh label create enhancement -c "#a2eeef" -d "New feature or request" 2>$null
  gh label create docs -c "#0075ca" -d "Documentation" 2>$null
} catch {}

# Commit
Push-Location $RepoDir
git add .
git commit -m "docs(seed): business plan, roadmap, architecture, policy schema, templates"
git push
Pop-Location

Write-Host "Seeded CoLaminar with plans and templates."
