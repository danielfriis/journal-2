// Puts the favicon of the linked site in front of the text of every external link.
// Icons come from DuckDuckGo's favicon service. Opt a link (or a whole block) out with data-no-favicon.
document.addEventListener("DOMContentLoaded", () => {
  for (const link of document.querySelectorAll("a[href^='http']")) {
    if (link.hostname === location.hostname || link.closest("[data-no-favicon]")) continue

    const walker = document.createTreeWalker(link, NodeFilter.SHOW_TEXT, { acceptNode: (node) => node.textContent.trim() ? NodeFilter.FILTER_ACCEPT : NodeFilter.FILTER_SKIP })
    const text = walker.nextNode()
    if (!text) continue

    const icon = document.createElement("img")
    icon.src = `https://icons.duckduckgo.com/ip3/${link.hostname}.ico`
    icon.alt = ""
    icon.className = "favicon"
    icon.loading = "lazy"
    icon.onerror = () => icon.remove()
    text.parentNode.insertBefore(icon, text)
  }
})
