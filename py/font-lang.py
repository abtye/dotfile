#!/usr/bin/python3
import subprocess

family = "sans-serif"

languages = {
    "zh-cn": ["简体中文", "Noto Sans SC"],
    "zh-tw": ["繁体中文", "Noto Sans TC"],
    "zh-hk": ["香港繁体", "Noto Sans HK"],
    "ja": ["日语", "Noto Sans JP"],
    "ko": ["韩语", "Noto Sans KR"],
    "th": ["泰语", "Noto Sans Thai"],
    "vi": ["越南语", "Noto Sans"],
    "km": ["柬埔寨语", "Noto Sans Khmer"],
    "my": ["缅甸语", "Noto Sans Myanmar"],
    "lo": ["老挝语", "Noto Sans Lao"],
    "hi": ["印地语", "Noto Sans Devanagari"],
    "bn": ["孟加拉语", "Noto Sans Bengali"],
    "ta": ["泰米尔语", "Noto Sans Tamil"],
    "te": ["泰卢固语", "Noto Sans Telugu"],
    "ml": ["马拉雅拉姆语", "Noto Sans Malayalam"],
    "ar": ["阿拉伯语", "Noto Sans Arabic UI"],
    "fa": ["波斯语", "Noto Sans Arabic UI"],
    "he": ["希伯来语", "Noto Sans Hebrew"],
    "ur": ["乌尔都语", "Noto Nastaliq Urdu"],
    "ru": ["俄语", "Noto Sans"],
    "el": ["希腊语", "Noto Sans"],
    "uk": ["乌克兰语", "Noto Sans"],
    "pl": ["波兰语", "Noto Sans"],
    "cs": ["捷克语", "Noto Sans"],
    "hu": ["匈牙利语", "Noto Sans"],
    "am": ["阿姆哈拉语", "Noto Sans Ethiopic"],
    "ka": ["格鲁吉亚语", "Noto Sans Georgian"],
    "ti": ["提格雷尼亚语", "Noto Sans Ethiopic"],
    "si": ["僧伽罗语", "Noto Sans Sinhala"],
    "bo": ["藏语", "Noto Serif Tibetan"],
}

quantityOfLanguage = len(languages)
quantityOfError = 0

for lang in languages:
    result = subprocess.run(
        ["fc-match", f"{family}:lang={lang}"],
        capture_output=True,  # 捕获输出
        text=True,  # 返回字符串（否则返回字节）
        check=False,  # 非零退出码不抛异常
    )
    nameOfLanguage = languages[lang][0]
    currentFont = result.stdout.split('"')[1]
    bestFont = languages[lang][1]
    if currentFont != bestFont:
        print(
            f"\x1b[31m{lang} {nameOfLanguage}设置不正确，当前字体为{currentFont}，最好为{bestFont}\x1b[0m"
        )
        quantityOfError += 1

if quantityOfError == 0:
    print("\x1b[32m所有语言均为Noto字体\x1b[0m")
