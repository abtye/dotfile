tmpFile="/tmp/v2ray-free"
curl https://cdn.jsdelivr.net/gh/aiboboxx/v2rayfree/v2 | base64 -d > $tmpFile
echo 共 `wc -l < $tmpFile` 个节点

