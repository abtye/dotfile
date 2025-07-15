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