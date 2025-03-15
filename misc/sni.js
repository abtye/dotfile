#!/usr/bin/node

"use strict"

const browser = "chromium"
const process = require("process")

function init() {
    // 读取命令行输入
    let mode = process.argv[2]
    if (mode === undefined) {
        // 没有指定配置文件
        mode = ""
    } else if ("APRapr".includes(mode) && mode.length === 1) {
        // APR模式
        mode = `-${mode.toUpperCase()}`
    } else {
        console.error("参数错误")
    }
    const configFile = `Cealing-Host/Cealing-Host${mode.toUpperCase()}.json`
    console.log(`配置文件：${configFile}`)
    main(configFile)
}

function main(configFile) {
    const fs = require("fs")
    const child_process = require("child_process")
    let u = 0
    let hostRules = []
    let resolverRules = []
    const hostJSON = fs.readFileSync(configFile, "utf8")
    const sni = JSON.parse(hostJSON)
    for (let domains of sni) {
        for (let name of domains[0]) {
            // 上游配置文件中存在以$和#开头的部分，意义不明，实际命令行中也没有相关内容，故跳过
            if (name[0] === "$" || name[0] === "#") {
                continue
            }
            // 如果没有指定映射目标，就映射为Ux
            let target = domains[1] ? domains[1] : "U" + u
            hostRules.push(`MAP ${name} ${target}`)
            resolverRules.push(`MAP ${target} ${domains[2]}`)
        }
        u++
    }
    // 因为改了SNI，必须忽略证书错误
    // 加--test-type不会有“您使用的是不受支持的命令行标记”
    let finalCMD = `${browser} --host-rules="${hostRules.join(",")}" --host-resolver-rules="${resolverRules.join(",")}" --test-type --ignore-certificate-errors`
    // 启动浏览器
    child_process.exec(finalCMD)
}

init()
