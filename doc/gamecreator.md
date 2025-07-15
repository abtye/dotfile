# 某 Game Creator 游戏破解

## 前言

在贴吧上找到了资源，但是游戏只有 Windows 版本。

在游戏根目录用 VSCode 的 Live Server 居然能在浏览器里玩，于是就没去折腾。

但是偶然清理了一次 Chromium 历史数据，存档就没了！！！

而且要是不用 VSCode 的 Liver Server，换 npm 的 http-server，原本在 Live Server 中的数据不会跑到 http-server 中

并且，用`http://127.0.0.1:3000`和`http://localhost:3000`的存档还不一样

突然发现，居然是基于 nw.js 的，尝试直接把 Windows 的 nw.js 替换为 Linux 的，不行，会弹窗"please run steam!"，点击确定之后游戏就关闭了

这应该是某种类似 DRM 保护的东西，尝试破解一下

## 去"DRM"

直接用 VSCode 打开游戏目录，搜索"please run steam"，没搜到

改搜索"please"，发现在加密的`script.js`中有出现

```js
alert(%22please%20run%20steam%20!%22)%3B%0A%20%20%20%20%20%20%20%20%20%20%20%20%2F%2Fwindow.close()
```

这是一段加密的代码，结合末尾的`window.close()`，这就是我们要找的

直接删掉`window.close()`倒也可以，但是一回到主界面都会弹窗，很烦

诶！`%20`等不就是URL编码吗？

直接让AI写一个破解脚本（实测后面还有一大堆没有被解码，不过足够了）

<details>

<summary>脚本.py</summary>

```python
#!/usr/bin/env python3
import urllib.parse
import sys
from pathlib import Path

def decode_file(input_path, output_path=None):
    """
    解码URL编码的JavaScript文件
    :param input_path: 输入文件路径
    :param output_path: 输出文件路径（可选，默认为在原文件名后加上_decoded）
    """
    if output_path is None:
        # 如果没有指定输出路径，在原文件名后加上_decoded
        input_path = Path(input_path)
        output_path = input_path.parent / f"{input_path.stem}_decoded{input_path.suffix}"
    
    # 使用二进制模式读取，避免编码问题
    with open(input_path, 'rb') as f:
        content = f.read().decode('utf-8')
    
    # 解码URL编码的内容
    decoded_content = urllib.parse.unquote(content)
    
    # 统一换行符为Unix风格（LF）
    decoded_content = decoded_content.replace('\r\n', '\n').replace('\r', '\n')
    
    # 写入解码后的内容
    with open(output_path, 'w', encoding='utf-8', newline='\n') as f:
        f.write(decoded_content)
    
    print(f"解码完成！")
    print(f"输出文件：{output_path}")

if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("使用方法：")
        print("python url_decode.py 输入文件路径 [输出文件路径]")
        sys.exit(1)
    
    input_file = sys.argv[1]
    output_file = sys.argv[2] if len(sys.argv) > 2 else None
    
    decode_file(input_file, output_file) 
```

</details>

破解之后找到以下代码

```js
SteamSDK.safeTest = function () {
    var code = SteamSDK.safeCode
    if (code == 2345 || code == 2346) {
        alert("please run steam !")    // 就是这一行
        window.close()    // 和这一行
        return false
    }
}
```

现在只需要在原先的`script.js`中这两行前免得`%20%20`（2个空格）改成`%2F%2F`（也就是`//`注释符号）就行啦

使用 sed 修改

```bash
sed -s 's/%20%20alert(%22please%20run%20steam%20!%22)%3B%0A%20%20%20%20%20%20%20%20%20%20%20%20window.close()/%2F%2Falert(%22please%20run%20steam%20!%22)%3B%0A%20%20%20%20%20%20%20%20%20%20%2F%2Fwindow.close()/' script.js > 1.js && mv 1.js script.js
```

执行 `./nw`，游戏启动！

## 将浏览器中的存档保存

### 分析

在游戏的根目录下，运行

```bash
http-server -p 3000
# 或者
pnpx serve .
# 或者 VSCode 的 Live Server 等等等等
```

居然没有屏蔽F12，直接打开控制台

被`debugger`卡住了，不慌，直接注释

```bash
sed -s 's/%20%20debugger/%2F%2Fdebugger/' script.js > 1.js && mv 1.js script.js
```

首先查看`应用 > 存储`，看来只用了 IndexedDB

IndexDB里有一个`0.8030579368153967-1713699899018`，在`0.8030579368153967-1713699899018`里又有一个`GC_Cache`，里面只有一项，值似乎是个 json,其中 value 不像是文本，以`PK`开头，貌似是个zip

通过`file <游戏根目录>/savedata/life.gcdata`得知`life.gcdata`也是 zip，那这应该就是的存档了

在解码后的`script_decoded.js`中搜索`gcdata`，在第2个结果中找到了

```js
ZipManager.zipCompress("gcdata", dataObject, function (buffer) {
    var bufferArray = new Uint8Array(buffer)
    var bufferText = ''
    for (var i = 0; i < bufferArray.length; i++) {
        bufferText += String.fromCharCode(bufferArray[i])
    }
    // 这里有 IndexedDB
    IndexedDBManager.setIndexDB(localURL, bufferText, function (success) {
        onSaveFin && onSaveFin.delayRun(0, null, [success, localURL])
    })
}, Config.z1)
```

果然有`IndexedDB`！

既然这里有`IndexedDBManager.setIndexDB`，那应该也有`IndexedDBManager.getIndexDB`

搜索一番，果然第5个就是我们想要的内容

```js
SinglePlayerGame.loadSaveFile = function (url, complete, syncCallbackWhenAssetExist, useRef, onErrorTips) {
    // 省略了一些代码
    IndexedDBManager.getIndexDB(url, function (value) {
        ZipManager.zipDeCompressText(value, function (text) {
            try {
                var jsonObj = JSON.parse(text)
                complete.delayRun(0, null, [jsonObj])
            }
            catch (e) {
                try {
                    complete.delayRun(0, null, [JSON.parse(value)])
                }
                catch (e) {
                    complete.delayRun(0, null, [null])
                }
            }
        }, Config.z1)
    })
    // 省略了一些代码
}
```

搜索`SinglePlayerGame.loadSaveFile`，找到

```js
SinglePlayerGame.loadLifeData = function (onFin) {
    var _this_1 = this
    var url = SinglePlayerGame.GC_LIFE_DATA_PATH
    SinglePlayerGame.loadSaveFile(SinglePlayerGame.GC_LIFE_DATA_PATH_BAK, Callback.New(function (data) {
        SinglePlayerGame.disposeSaveFile(SinglePlayerGame.GC_LIFE_DATA_PATH_BAK, true)
        if (data) {
            SinglePlayerGame.doLoadLifeData(data, onFin)
        }
        else {
            SinglePlayerGame.loadSaveFile(url, Callback.New(function (data) {
                SinglePlayerGame.disposeSaveFile(url, true)
                SinglePlayerGame.doLoadLifeData(data, onFin)
            }, _this_1), false, true, false)
        }
    }, this), false, true, false)
}
```

VSCode 中找不到`SinglePlayerGame.GC_LIFE_DATA_PATH`和`SinglePlayerGame.GC_LIFE_DATA_PATH_BAK`的定义，在 Chromium 的控制台得到

```
SinglePlayerGame.GC_LIFE_DATA_PATH
http://127.0.0.1:3000//0.8030579368153967-1713699899018/savedata/life.gcdata

SinglePlayerGame.GC_LIFE_DATA_PATH_BAK
'http://127.0.0.1:3000//0.8030579368153967-1713699899018/savedata/life.gcdatabak
```

所以`SinglePlayerGame.loadSaveFile`的参数应该就是`SinglePlayerGame.GC_LIFE_DATA_PATH`了

在 Chromium 中运行下面的代码，得到一个没什么用的对象，里面一大堆 null

```js
IndexedDBManager.getIndexDB(SinglePlayerGame.GC_LIFE_DATA_PATH, function (value) {
    ZipManager.zipDeCompressText(value, function (text) {

        var jsonObj = JSON.parse(text)
        console.log(jsonObj)

    }, Config.z1)
})
```

但是从这里我们可以推出，`value`就是存档`life.gcdata`的二进制数据了

### 破解

先用下面的代码下载下来

```js
function downloadGCdata(text) {
    // 将文本转换为 Uint8Array
    const encoder = new TextEncoder()
    const binaryData = encoder.encode(text)

    // 创建 Blob 对象
    const blob = new Blob([binaryData], { type: "application/zip" })

    // 创建下载链接
    const url = URL.createObjectURL(blob)
    const link = document.createElement("a")
    link.href = url
    link.download = "life.gcdata.txt"

    // 触发下载
    document.body.appendChild(link)
    link.click()

    // 清理
    document.body.removeChild(link)
    URL.revokeObjectURL(url)
}

IndexedDBManager.getIndexDB(SinglePlayerGame.GC_LIFE_DATA_PATH, function (value) {
    downloadGCdata(encodeURIComponent(value))
})
```

> 不知道为什么，一定要先`encodeURIComponent`，不然 7zip 就识别文件损坏

再用 Python 解码

```python
from urllib.parse import unquote

def decode_file():
    # 读取编码后的文本
    with open("life.gcdata.txt", "r") as f:
        encoded_text = f.read().strip()
    
    # 使用urllib.parse.unquote解码encodeURIComponent编码的内容
    decoded_text = unquote(encoded_text)
    
    # 将解码后的文本转换为二进制数据
    binary_data = decoded_text.encode("latin1")  # 使用latin1编码来保持字节值不变
    
    # 将二进制数据写入新文件
    with open("life.gcdata", "wb") as f:
        f.write(binary_data)

if __name__ == "__main__":
    try:
        decode_file()
        print("解码完成！输出文件为 life.gcdata")
    except Exception as e:
        print(f"发生错误：{str(e)}") 
```

7zip 识别正常，放到`<游戏根目录>/savedata/life.gcdata`也可以识别

大功告成！

### 尝试获取 life.gcdata 的密码（失败）

转到`ZipManager.zipCompress`的定义发现

```js
ZipManager.zipCompress = function (fileName, data, onFin, password) {
    // 一些代码
}
```

所以`Config.z1`就是密码了！

在 Chromium 的控制台中输入 `Config.z1`，得到了

```
1|/|5|7|9|4|1|5|:|1|2|7|5|8|:|9|8|5|5|.|2|8|1|3|:|8|8|1|6|9|2|1|6
```

研究了几个小时，发现不了什么，把这个作为密码也解压不了`life.gcdata`，只好放弃
