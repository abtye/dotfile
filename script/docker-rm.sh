#!/usr/bin/bash

echo 删除 Docker 的网络、镜像
docker network prune
docker image prune -a
