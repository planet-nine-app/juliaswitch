import { info } from "@tauri-apps/plugin-log";
//const { invoke } = window.__TAURI__.core;

info("foo");

window.addEventListener("DOMContentLoaded", () => {
info("DOMContentLoaded");
  document.querySelector('#foo').innerHTML = "can i change this";

info("getting button");
  const advanceButton = document.querySelector('#advanceButton')
  advanceButton.onclick = () => {
    window.alert('button pushed');
  };
  advanceButton.style.cursor = 'pointer';
info("Should have added everything");

});

/*import { appWindow } from "@tauri-apps/api/window";
const unlisten = await appWindow.onResized(({ payload: size }) => {
 console.log('Window resized', size);
});

console.log('calling unlisten');
// you need to call unlisten if your handler goes out of scope e.g. the component is unmounted
unlisten();*/
