param([string]$RepoRoot=".")
$ErrorActionPreference="Stop"

# Build candidate files safely (map rel → full path one-by-one)
$rel = @("plane-app\index.html","plane-app\preview\index.html")
$targets = @()
foreach($r in $rel){
  $p = Join-Path $RepoRoot $r
  if (Test-Path $p) { $targets += $p }
}
if (-not $targets){ Write-Host "ℹ️ No plane pages found."; exit 0 }

$intro = @"
<details id=""plane-what"" style=""max-width:820px;border:1px solid #233047;border-radius:10px;padding:10px 12px;"">
  <summary style=""cursor:pointer;color:#cfe2ff;"">What is the Perspective Plane?</summary>
  <div style=""margin-top:10px;color:#9fb0c6;"">
    <p><b>CoPolitic</b> isn’t a political org and doesn’t endorse parties. It borrows a <i>modeling</i> frame from CoCivium: we compare positions across two civic axes instead of a 1-D left↔right line.</p>
    <ul style=""margin:8px 0 0 20px;"">
      <li><b>X: Commons → Commerce</b> — orientation toward <i>shared resource stewardship</i> vs <i>market-first production & exchange</i>.</li>
      <li><b>Y: Club → Crown</b> — coordination via <i>voluntary/peer associations</i> vs <i>central authority/state instruments</i>.</li>
      <li><b>Points</b> aggregate many domains (economy, civic, culture, institutions…). Weights let you stress-test assumptions; <b>Equalize</b> resets them.</li>
      <li><b>Use</b>: Toggle layers (countries, US parties, CoCivium modes). Click a dot for domain notes & sources.</li>
    </ul>
  </div>
</details>
"@

$glossary = @"
<section id=""plane-glossary"" style=""margin:18px 0 4px;"">
  <h2 style=""font-size:16px;color:#e7eefc;margin:0 0 6px;"">Glossary (quick reads)</h2>
  <div style=""max-width:880px;color:#9fb0c6;display:grid;gap:8px;"">
    <div><b data-term=""commons"">Commons</b> — shared assets & infrastructures (knowledge, public goods, ecological capital) governed for broad benefit.</div>
    <div><b data-term=""commerce"">Commerce</b> — private production & exchange, price signals, competitive markets; emphasis on enterprise and capital formation.</div>
    <div><b data-term=""club"">Club</b> — federated, voluntary, bottom-up coordination (guilds, co-ops, associations, DAOs, standards bodies).</div>
    <div><b data-term=""crown"">Crown</b> — centralized, top-down coordination (constitutional states, regulators, executive agencies, treaties, central banks).</div>
  </div>
</section>
"@

foreach($f in $targets){
  $html = Get-Content $f -Raw

  # Replace old explainer if present
  $html = [regex]::Replace(
    $html,
    '(?is)<details[^>]*>\s*<summary[^>]*>.*?What am I looking at\?.*?</summary>.*?</details>',
    $intro,
    [System.Text.RegularExpressions.RegexOptions]::Singleline
  )

  # If no explainer, inject after </header>
  if ($html -notmatch 'id="plane-what"'){
    $html = [regex]::Replace(
      $html,'(?is)(</header>)',"`$1`r`n$intro",
      [System.Text.RegularExpressions.RegexOptions]::Singleline
    )
  }

  # Glossary before Methods; else before </body>
  if ($html -notmatch 'id="plane-glossary"'){
    if ($html -match 'id="plane-methods"'){
      $html = [regex]::Replace(
        $html,'(?is)(<section[^>]+id="plane-methods")',"$glossary`r`n`$1",
        [System.Text.RegularExpressions.RegexOptions]::Singleline
      )
    } else {
      $html = [regex]::Replace(
        $html,'(?is)(</body>)',"$glossary`r`n`$1",
        [System.Text.RegularExpressions.RegexOptions]::Singleline
      )
    }
  }

  Set-Content -Encoding utf8 -NoNewline $f -Value $html
}
Write-Host "✅ Plane pages: explainer + glossary injected"