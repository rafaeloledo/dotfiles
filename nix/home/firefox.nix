{ pkgs, inputs, ... }:

{
  programs.firefox = {
    enable = true;
    profiles.default.extraConfig = ''
      user_pref("ui.key.menuAccessKeyFocuses", false);
      user_pref("extensions.pocket.enabled", false);
      user_pref("full-screen-api.transition-duration.enter", "0 0");
      user_pref("full-screen-api.transition-duration.leave", "0 0");
      user_pref("full-screen-api.transition.timeout", 0);
      user_pref("full-screen-api.warning.timeout", 0);
      user_pref("full-screen-api.warning.delay", -1);
      user_pref("browser.tabs.firefox-view", false);
      user_pref("browser.uitour.enabled", false);

      //user_pref("browser.cache.disk.enable", false);
      // Graphics
      //user_pref("gfx.webrender.all", true);
      //user_pref("gfx.webrender.precache-shaders", true);
      //user_pref("gfx.webrender.compositor", true);
      //user_pref("gfx.canvas.accelerated", true);
      //user_pref("layers.gpu-process.enabled", true);
      //user_pref("media.hardware-video-decoding.enabled", true);

      user_pref("browser.newtabpage.activity-stream.default.sites", "");
      user_pref("browser.newtabpage.activity-stream.feeds.topsites", false);
      user_pref("browser.newtabpage.activity-stream.feeds.section.topstories", false);
      user_pref("signon.rememberSignons", false);
    '';
  };
}