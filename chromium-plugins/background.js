console.log("background loaded");

chrome.commands.onCommand.addListener(function (command) {
  console.log("command listener");
  if (command === "random_tab_switch") {
    chrome.tabs.query({ currentWindow: true }, function (tabs) {
      if (tabs.length > 1) {
        const randomIndex = Math.floor(Math.random() * tabs.length);
        const randomTabId = tabs[randomIndex].id;
        chrome.tabs.update(randomTabId, { active: true });
      }
    });
  }
});
