import json
import os
import threading
from turtle import down
from urllib.request import urlretrieve
from urllib.error import URLError

json_file = "mujica.json"


url_list = {}
output_dir = ""

with open(json_file) as f:
    json_data = json.load(f)["data"]["packages"][0]
    emotes = json_data["emote"]
    output_dir = json_data["text"]
    os.makedirs(output_dir, exist_ok=True)

    for i in emotes:
        url_list[i["text"] + i["meta"]["alias"]] = i["url"]


def download(url, filename):
    try:
        # 下载文件
        print(f"正在下载 {url} 为 {filename}.png")
        urlretrieve(url, f"{output_dir}/{filename}.png")
        print(f"成功下载 {filename}.png")

    except (URLError, Exception) as e:
        print(f"下载 {url} 失败: {e}")



# for i in url_list:
    

# 创建并启动线程
threads = []
for i in url_list:
    thread = threading.Thread(target=download, args=(url_list[i],i))
    threads.append(thread)
    thread.start()

# 等待所有线程完成
for thread in threads:
    thread.join()

print("所有下载任务完成")
