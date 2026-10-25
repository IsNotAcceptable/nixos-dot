// ==UserScript==
// @include   main
// @ignorecache
// ==/UserScript==

class FloatingURLBarController {
  constructor() {
    this.urlBar = document.getElementById('urlbar');
  }

  init() {
    if (!this.urlBar) return;

    if (window.location.protocol === 'about:' || window.location.href.startsWith('chrome://')) {
      return;  
    }

    this.urlBar.addEventListener('focus', () => {
      this.urlBar.setAttribute('open', 'true');
    }, true);

    this.urlBar.addEventListener('blur', () => {
      this.urlBar.removeAttribute('open');
    }, true);

    document.addEventListener('keydown', (e) => {
      if (e.key === 'Escape' && this.urlBar.getAttribute('open')) {
        this.urlBar.removeAttribute('open');
        this.urlBar.blur();
      }
    });
  }
}

if (!window.floatingURLBar) {
  window.floatingURLBar = new FloatingURLBarController();
  window.floatingURLBar.init();
}
