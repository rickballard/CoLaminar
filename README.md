# CoLaminar — Advice-Bomb (CoEvolution + Installers)

**What:** A portable bundle that drops a `/coevolution/` page into any CoSuite repo, upgrades plane UX
(auto-scale + mobile-friendly slider), and injects an explainer + glossary.

**Get the zip:** see the latest release → [advice-bomb-v1](https://github.com/rickballard/CoLaminar/releases/tag/advice-bomb-v1)

## Quick start (from target repo root)
```powershell
$zip = Join-Path $HOME 'Downloads\CoLaminar-advice-bomb.zip'   # put the release asset here
$temp = Join-Path $env:TEMP ("coab-" + [Guid]::NewGuid()); New-Item -ItemType Directory -Force $temp | Out-Null
Expand-Archive -Path $zip -DestinationPath $temp -Force
pwsh -File (Join-Path $temp 'Run-AdviceBomb.ps1') -RepoRoot .
git add .; git commit -m "Apply CoLaminar advice-bomb"; git push