#!/usr/bin/node

"use strict"

// 在这里改浏览器
const browser = "chromium"

const process = require("process")
const fs = require("fs")

function init() {
    // 读取命令行输入
    let mode = process.argv[2]
    if (mode === undefined) {
        // 没有指定配置文件
        mode = ""
    } else if (mode.length === 1) {
        // 指定配置
        mode = `-${mode.toUpperCase()}`
    } else {
        throw "参数格式错误"
    }
    const configFile = `Cealing-Host/Cealing-Host${mode.toUpperCase()}.json`
    fs.exists(configFile, (exists) => {
        if (!exists) {
            throw "配置文件不存在"
        } else {
            console.log(`配置文件：${configFile}`)
            main(configFile)
        }
    });

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
            // 上游配置文件以$和#开头的部分作为全局或非全局的区分，但是这个脚本用不到
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
    /*
        如果遇到E2BIG错误，是配置文件太大了，Unix系统对命令行参数和环境变量的总大小有限制
        使用 getconf ARG_MAX 查看大小限制
        典型值（Linux）：2097152（2MB）
    */
    let finalCMD = `${browser} --host-rules="${hostRules.join(",")}" --host-resolver-rules="${resolverRules.join(",")}" --test-type --ignore-certificate-errors`
    // 启动浏览器
    child_process.exec(finalCMD)
}

init()