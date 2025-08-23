
// BrightFeed content script (MVP)
(function(){
  const SELECTORS = {
    shorts: [
      'ytd-rich-shelf-renderer[is-shorts]',
      'ytd-reel-shelf-renderer',
      'ytd-reel-video-renderer',
      'a[title="Shorts"]',
      'a[href*="/shorts/"]',
      'yt-chip-cloud-chip-renderer[chip-style*="SHORTS"]'
    ],
    comments: ['#comments', 'ytd-comments'],
    home_recs: ['ytd-browse[page-subtype="home"] #contents ytd-rich-grid-row']
  };

  let policy = {
    minVideoMinutes: 6,
    hide: ["shorts","comments","home_recommendations"]
  };

  function parseDurationToSeconds(txt){
    // Expects formats like "12:34" or "1:02:03"
    if(!txt) return 0;
    const parts = txt.trim().split(":").map(Number);
    if(parts.some(isNaN)) return 0;
    let secs = 0, mult = 1;
    while(parts.length){
      secs += parts.pop() * mult;
      mult *= 60;
    }
    return secs;
  }

  function hideElements(){
    // Apply hide rules
    if(policy.hide.includes("shorts")){
      SELECTORS.shorts.forEach(sel => document.querySelectorAll(sel).forEach(el => el.style.display="none"));
    }
    if(policy.hide.includes("comments")){
      SELECTORS.comments.forEach(sel => document.querySelectorAll(sel).forEach(el => el.style.display="none"));
    }
    if(policy.hide.includes("home_recommendations")){
      SELECTORS.home_recs.forEach(sel => document.querySelectorAll(sel).forEach(el => el.style.display="none"));
    }

    // Enforce min length in tiles (rudimentary)
    const minSecs = (policy.minVideoMinutes || 0) * 60;
    if(minSecs > 0){
      document.querySelectorAll('ytd-rich-item-renderer,ytd-video-renderer').forEach(card => {
        const durEl = card.querySelector('ytd-thumbnail-overlay-time-status-renderer span, span.ytd-thumbnail-overlay-time-status-renderer');
        const dur = durEl ? parseDurationToSeconds(durEl.textContent) : 0;
        const isShort = card.querySelector('a[href*="/shorts/"]');
        if(isShort || (dur > 0 && dur < minSecs)){
          card.style.display = "none";
        }
      });
    }
  }

  function observe(){
    const mo = new MutationObserver((muts)=>{
      hideElements();
    });
    mo.observe(document.documentElement, {subtree:true, childList:true});
    hideElements();
  }

  // Load policy from storage
  chrome.storage.sync.get(["brightfeedPolicy"], (res)=>{
    if(res && res.brightfeedPolicy){
      try{ policy = Object.assign(policy, res.brightfeedPolicy); }catch(e){}
    }
    observe();
  });

  // React to policy changes without reload
  chrome.storage.onChanged.addListener((changes, area)=>{
    if(area === "sync" && changes.brightfeedPolicy){
      try{
        policy = Object.assign(policy, changes.brightfeedPolicy.newValue || {});
        hideElements();
      }catch(e){}
    }
  });
})();
