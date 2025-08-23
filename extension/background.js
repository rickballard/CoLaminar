
chrome.runtime.onInstalled.addListener(() => {
  chrome.storage.sync.get(["brightfeedPolicy"], (res)=>{
    if(!res.brightfeedPolicy){
      const defaultPolicy = {
        minVideoMinutes: 6,
        hide: ["shorts","comments","home_recommendations"]
      };
      chrome.storage.sync.set({brightfeedPolicy: defaultPolicy});
    }
  });
});
