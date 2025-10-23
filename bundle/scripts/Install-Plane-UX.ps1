param([string]$RepoRoot=".")
$ErrorActionPreference="Stop"

$planeSafe = Join-Path $RepoRoot 'plane-app\plane-safe.js'
$planeUx   = Join-Path $RepoRoot 'plane-app\plane-ux.js'
if (!(Test-Path $planeSafe)) { Write-Host "ℹ️ Skipping auto-scale (no plane-safe.js)"; exit 0 }

$js = Get-Content $planeSafe -Raw
if ($js -notmatch 'function __autoUiScale'){
$js = $js + @"
function __autoUiScale(containerPx, dpr){
  const minSide = containerPx;
  let base = (minSide<420? 2.4 : minSide<640? 2.0 : minSide<900? 1.6 : 1.3);
  if (dpr>=3) base *= 1.15; if (dpr<=1) base *= 0.9;
  return Math.max(1.0, Math.min(3.2, base));
}
"@
}
if ($js -notmatch 'ResizeObserver\('){
$js = $js + @"
;(() => {
  const canvas = document.getElementById("plane-canvas"); if (!canvas) return;
  const compute = () => {
    const rect = canvas.getBoundingClientRect();
    const minSide = Math.min(rect.width, rect.height);
    const dpr = (window.devicePixelRatio||1);
    const persisted = Number(localStorage.getItem("PLANE_UI_SCALE"));
    if (!(Number.isFinite(persisted) && persisted>0)) { try { window.PLANE_UI_SCALE = __autoUiScale(minSide, dpr); } catch(_) {} }
    try { window.draw && window.draw(); } catch(_) {}
  };
  compute();
  try { new ResizeObserver(compute).observe(canvas); } catch(_) { window.addEventListener("resize", compute, {passive:true}); }
})();
"@
}
Set-Content -Encoding utf8 -NoNewline $planeSafe -Value $js

if (Test-Path $planeUx) {
  $ux = Get-Content $planeUx -Raw
  if ($ux -notmatch '#plane-size-ctrl'){
    $ux = $ux + @"
;(() => {
  const style = document.createElement('style');
  style.textContent = '@media (max-width:520px){ #plane-size-ctrl{ display:none !important; } }';
  document.head.appendChild(style);
})();
"@
    Set-Content -Encoding utf8 -NoNewline $planeUx -Value $ux
  }
}
Write-Host "✅ Plane UX: auto-scale + mobile-friendly slider"
