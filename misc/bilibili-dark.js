window.onload = function () {
    let tags = ["span", "svg", "p", ".bili-header__bar", ".right-container", ".left-container", "#mirror-vdcon"]
    // let tags = [ "*"]

    for (let i of tags) {
        for (let j of document.querySelectorAll(i)) {
            j.style.color = "#ffffff"
            j.style.backgroundColor = "#333333"
            // j.setAttribute("style", "color:#ffffff !important")
            // j.setAttribute("style", "color:#ffffff !important")
        }
    }
    for(let i of document.querySelectorAll("div")){
        if(i.id="content"){
            console.log(1)
        }
    }
}
function randomHexColor() {
    return "#" + Math.floor(Math.random() * 16777215).toString(16)
}