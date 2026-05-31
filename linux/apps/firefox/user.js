// Symlinked into ~/.config/mozilla/firefox/<profile>/user.js

user_pref("ui.key.menuAccessKeyFocuses", false);

// Put history/bookmarks above search suggestions in the address bar,
// pushing Firefox Suggest closer to the top of the results list.
user_pref("browser.urlbar.showSearchSuggestionsFirst", false);

// Force dark mode for both Firefox chrome and web content.
user_pref("browser.theme.toolbar-theme", 0);            // 0=dark, 1=light, 2=auto
user_pref("browser.theme.content-theme", 0);            // 0=dark, 1=light, 2=auto
user_pref("layout.css.prefers-color-scheme.content-override", 0); // 0=dark

// Hide "Recent activity" / "View recent browsing across windows and devices"
// on the new tab and Firefox View pages.
user_pref("browser.newtabpage.activity-stream.feeds.section.highlights", false);
user_pref("browser.newtabpage.activity-stream.feeds.sections.topstories", false);
user_pref("browser.tabs.firefox-view", false);

// Enable userChrome.css customizations (hides the Firefox View button, etc.)
user_pref("toolkit.legacyUserProfileCustomizations.stylesheets", true);
