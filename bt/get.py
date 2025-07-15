import requests
import time
import websockets
import asyncio
import threading
import socket
import os
import glob

links = []
TIMEOUT = 3
available_urls = []
threads = []
numberOfTotalTrackers = 0
start_time = int(time.time())
lock = threading.Lock()  # 用于线程安全
logFilePath = "/tmp/get-tracker.log"
logFile = open(logFilePath, "w")


def log(info):
    print(info, file=logFile)


def getLinks():
    print("开始下载")
    TRACKER_URLS = (
        "https://cdn.jsdelivr.net/gh/ngosang/trackerslist@master/trackers_best.txt",
        "https://cdn.jsdelivr.net/gh/XIU2/TrackersListCollection@master/best.txt",
        "https://cdn.jsdelivr.net/gh/adysec/tracker@main/trackers_best.txt",
        # "https://cdn.jsdelivr.net/gh/DeSireFire/animeTrackerList/AT_all.txt",
        "https://newtrackon.com/api/live",
    )
    all_links = set()
    for url in TRACKER_URLS:
        try:
            response = requests.get(url, timeout=5)
            all_links = all_links.union(set(response.text.splitlines()))
        except requests.exceptions.RequestException as e:
            print(f"下载 {url} 失败: {e}")
    all_links.discard("")
    return list(all_links)


def test_wss_connection(thread_id):
    url = links[thread_id]

    async def connect():
        try:
            async with websockets.connect(url, open_timeout=TIMEOUT) as websocket:
                await websocket.send("")
                await websocket.recv()
                with lock:
                    available_urls.append(url)
        except Exception as e:
            log(f"线程{thread_id}: WSS 连接失败: {e}")

    asyncio.run(connect())


def test_http_connection(thread_id):
    url = links[thread_id]
    try:
        response = requests.get(url, timeout=TIMEOUT)
        if response.status_code == 200:
            with lock:
                available_urls.append(url)
        else:
            with open("/tmp/get-tracker.log", "w") as f:
                log(f"线程{thread_id}: HTTP 状态码 {response.status_code}")
    except Exception as e:
        with open("/tmp/get-tracker.log", "w") as f:
            log(f"线程{thread_id}: HTTP 连接失败: {e}")


def test_udp_connection(thread_id):
    available_urls.append(links[thread_id])
    # u = links[thread_id]
    # try:
    #     address = u.split("/")[2].split(":")
    #     UDP_IP = address[0]
    #     UDP_PORT = int(address[1])
    #     sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
    #     sock.sendto(b"1", (UDP_IP, UDP_PORT))
    #     sock.settimeout(TIMEOUT)
    #     try:
    #         sock.recvfrom(1024)
    #         with lock:
    #             available_urls.append(u)
    #     except socket.timeout:
    #         log(f"线程{thread_id}: UDP 没有收到回复")
    #     sock.close()
    # except Exception as e:
    #     log(f"线程{thread_id}: UDP 连接失败: {e}")


def test_all(links):
    for i, herf in enumerate(links):
        if herf.startswith("wss"):
            t = threading.Thread(target=test_wss_connection, args=(i,))
        elif herf.startswith("http"):
            t = threading.Thread(target=test_http_connection, args=(i,))
        elif herf.startswith("udp"):
            t = threading.Thread(target=test_udp_connection, args=(i,))
        else:
            log(f"线程{i}: 未知协议 {herf}")
            continue
        t.start()
        threads.append(t)


def main():
    global links, numberOfTotalTrackers
    links = getLinks()
    numberOfTotalTrackers = len(links)
    test_all(links)
    for t in threads:
        t.join()
    with open("good", "w") as f:
        for i in available_urls:
            f.write(f"{i}\n")
    print(f"可用数量: {len(available_urls)}/{numberOfTotalTrackers}")
    used_time = int(time.time()) - start_time
    print(f"用时{used_time}秒")
    print(f"日志输出到{logFilePath}")
    logFile.close()
    # 删除txt文件
    for file in glob.glob("./*.txt"):
        os.remove(file)


if __name__ == "__main__":
    main()
