{ config, pkgs, ... }:

{
  programs.firefox = {
    enable = true;
    profiles.default = {
      settings = {
        "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
	"sidebar.revamp" = false;
	"svg.context-properties.content.enabled" = true;
	"layout.css.has-selector.enabled" = true;
	"browser.urlbar.suggest.calculator" = true;
	"browser.urlbar.unitConversion.enabled" = true;
	"browser.urlbar.trimHttps" = true;
	"browser.urlbar.trimURLs" = true;
	"widget.gtk.rounded-bottom-corners.enabled" = true;
	"widget.gtk.ignore-bogus-leave-notify" = 1;
      };

      userContent = ''
        @import url("shyyoru/chrome/ShyYoru/content/shy-new-tab.css");
	@import url("shyyoru/chrome/ShyYoru/content/shy-sidebery.css");
	@import url("shyyoru/chrome/ShyYoru/content/shy-about.css");
	@import url("shyyoru/chrome/ShyYoru/content/shy-global-content.css");
	@import url("shyyoru/chrome/ShyYoru/shy-variables.css");
      '';

      userChrome = ''
	@import url("shyyoru/chrome/ShyYoru/shy-variables.css");
	@import url("shyyoru/chrome/ShyYoru/shy-global.css");
	@import url("shyyoru/chrome/ShyYoru/shy-sidebar.css");
	@import url("shyyoru/chrome/ShyYoru/shy-toolbar.css");
	@import url("shyyoru/chrome/ShyYoru/shy-navbar.css");
	@import url("shyyoru/chrome/ShyYoru/shy-findbar.css");
	@import url("shyyoru/chrome/ShyYoru/shy-controls.css");
	@import url("shyyoru/chrome/ShyYoru/shy-compact.css");
	@import url("shyyoru/chrome/ShyYoru/shy-icons.css");
	@import url("shyyoru/chrome/ShyYoru/shy-floating-search.css");
	@import url("shyyoru/chrome/ShyYoru/natsumi-floatingUrl.css");
      '';
    };
  };
}
