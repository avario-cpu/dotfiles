const TARGET_ZOOM = 1.1;
const PATH_MATCH = "/code";

function isTargetUrl(url) {
  if (!url) return false;
  try {
    const u = new URL(url);
    return u.hostname === "claude.ai" && u.pathname.startsWith(PATH_MATCH);
  } catch {
    return false;
  }
}

async function applyZoomIfNeeded(tabId, url) {
  if (!isTargetUrl(url)) return;

  // per-tab scope means this zoom change won't leak to other claude.ai tabs
  await chrome.tabs.setZoomSettings(tabId, { scope: "per-tab" });
  await chrome.tabs.setZoom(tabId, TARGET_ZOOM);
}

// fires on full navigation
chrome.tabs.onUpdated.addListener((tabId, changeInfo, tab) => {
  if (changeInfo.status === "complete") {
    applyZoomIfNeeded(tabId, tab.url);
  }
});

// fires on client-side SPA navigation (claude.ai/code likely uses history.pushState)
if (chrome.webNavigation) {
  chrome.webNavigation.onHistoryStateUpdated.addListener((details) => {
    applyZoomIfNeeded(details.tabId, details.url);
  });
}
