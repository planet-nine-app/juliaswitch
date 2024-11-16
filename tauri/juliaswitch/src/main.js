window.addEventListener("DOMContentLoaded", () => {
  document.querySelector('#foo').innerHTML = "can i change this";

  const advanceButton = document.querySelector('#advanceButton')
  advanceButton.onclick = () => {
    document.querySelector('#foo').innerHTML = 'button pushed';
    const widthAnim = document.createElementNS("http://www.w3.org/2000/svg", "animate");
    widthAnim.setAttribute("attributeName", "width");
    widthAnim.setAttribute("from", "100%");
    widthAnim.setAttribute("to", "5%");
    widthAnim.setAttribute("dur", "500ms");
    widthAnim.setAttribute("begin", "0s");
    widthAnim.setAttribute("fill", "freeze");

    const heightAnim = document.createElementNS("http://www.w3.org/2000/svg", "animate");
    heightAnim.setAttribute("attributeName", "height");
    heightAnim.setAttribute("from", "100%");
    heightAnim.setAttribute("to", "5%");
    heightAnim.setAttribute("dur", "500ms");
    heightAnim.setAttribute("begin", "0s");
    heightAnim.setAttribute("fill", "freeze");

    const starfield = document.querySelector("#starfield");
    console.log('starfield', starfield);
    starfield.appendChild(widthAnim);
    starfield.appendChild(heightAnim);

    widthAnim.beginElement();
    heightAnim.beginElement();



/*    const animations = `
      <animate 
        attributeName="width" 
        from="100%" 
        to="5%" 
        dur="1s"
        begin="0s"
        fill="freeze" />
      <animate 
        attributeName="height" 
        from="100%" 
        to="5%" 
        dur="1s"
        begin="0s"
        fill="freeze" />`;
      <animate 
        attributeName="x" 
        from="0" 
        to="5%" 
        dur="1s"
        fill="freeze" />
      <animate 
        attributeName="y" 
        from="0" 
        to="5%" 
        dur="1s"
        fill="freeze" />
      `;

    const starfield = document.querySelector("#starfield");
    const background = document.querySelector("#background");
    background.removeChild(starfield);
    starfield.insertAdjacentHTML('afterbegin', animations);
    background.appendChild(starfield);*/
  };
  advanceButton.style.cursor = 'pointer';

});


