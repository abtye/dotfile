const upload = []
const download = []
let num = 0

// 获取上传下载信息列表
const tds = document.querySelectorAll("table.dynamicTable")[1].querySelectorAll("tbody>tr>td")
for (let i of tds) {
    if (i.getAttribute("class") !== "invisible") {
        const bytes = i.innerText
        if (num % 2 === 0) {
            download.push(bytes)
        } else {
            upload.push(bytes)
        }
        num++
    }
}

// 计算 GiB
function getGigaByte(loads) {
    let byte = 0
    for (let i of loads) {
        const info = i.split(" ")
        let power = 0
        switch (info[1]) {
            case "GiB":
            power = 3
                break
            case "MiB":
            power = 2
                break
            case "KiB":
            power = 1
                break
            default:
                break
        }
        byte+=1024**power*parseFloat(info[0])
    }
    return (byte/1024**3).toFixed(2)
}

// 输出信息
const percent = parseInt(getGigaByte(upload))/parseInt(getGigaByte(download))
console.log("upload",getGigaByte(upload),"GiB")
console.log("download",getGigaByte(download),"GiB")
console.log("percent",(percent*100).toFixed(2),"%")
