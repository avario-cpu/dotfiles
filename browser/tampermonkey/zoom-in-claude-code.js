// ==UserScript==
// @name         Claude Code Extra Zoom
// @namespace    bro-tampermonkey
// @description  zoom more on code/ paths to compensate for what seems to be an inherently lower zoom level. Browser lvl Zoom level between all claude.ai paths are tied so we cant use that.
// @match        https://claude.ai/code*
// @match        https://claude.ai/code/*
// @grant        none
// @run-at       document-start
// ==/UserScript==

(function () {
  "use strict";

  const applyZoom = () => {
    document.documentElement.style.zoom = "105%";
  };

  applyZoom();

  // re-apply on SPA navigation, since claude.ai/code likely doesn't hard-reload between views
  const observer = new MutationObserver(applyZoom);
  observer.observe(document.documentElement, {
    childList: true,
    subtree: false,
  });
})();
