
function setForm(policy){
  document.getElementById('hide_shorts').checked = (policy.hide||[]).includes("shorts");
  document.getElementById('hide_comments').checked = (policy.hide||[]).includes("comments");
  document.getElementById('hide_home').checked = (policy.hide||[]).includes("home_recommendations");
  document.getElementById('min_minutes').value = policy.minVideoMinutes || 0;
}

function getFormPolicy(){
  const hide = [];
  if(document.getElementById('hide_shorts').checked) hide.push("shorts");
  if(document.getElementById('hide_comments').checked) hide.push("comments");
  if(document.getElementById('hide_home').checked) hide.push("home_recommendations");
  const minVideoMinutes = parseInt(document.getElementById('min_minutes').value || "0", 10);
  return { hide, minVideoMinutes };
}

function save(){
  const policy = getFormPolicy();
  chrome.storage.sync.set({brightfeedPolicy: policy}, ()=>{
    alert("Saved.");
  });
}

function reset(){
  const defaults = { hide: ["shorts","comments","home_recommendations"], minVideoMinutes: 6 };
  chrome.storage.sync.set({brightfeedPolicy: defaults}, ()=>{
    setForm(defaults);
    alert("Reset.");
  });
}

document.getElementById('save').addEventListener('click', save);
document.getElementById('reset').addEventListener('click', reset);

document.getElementById('import_json').addEventListener('change', async (e)=>{
  const file = e.target.files[0];
  if(!file) return;
  const text = await file.text();
  try{
    const obj = JSON.parse(text);
    const subset = {
      hide: obj.hide || [],
      minVideoMinutes: obj.minVideoMinutes || 0
    };
    chrome.storage.sync.set({brightfeedPolicy: subset}, ()=>{
      setForm(subset);
      alert("Imported policy.");
    });
  }catch(err){
    alert("Invalid JSON.");
  }
});

chrome.storage.sync.get(["brightfeedPolicy"], (res)=>{
  const policy = res.brightfeedPolicy || { hide: ["shorts","comments","home_recommendations"], minVideoMinutes: 6 };
  setForm(policy);
});
