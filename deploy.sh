#!/bin/bash


#!/bin/bash
set -e 

GITHUB_BASE="https://github.com/zeroclaw-labs/zeroclaw"
echo "当前使用源：${GITHUB_BASE}"
# 获取版本号
REMOTE_VERSION=$(curl -sI ${GITHUB_BASE}/releases/latest | grep -i location | awk -F '/' '{print $NF}' | tr -d '\r')

if [ -z "$REMOTE_VERSION" ]; then
    echo "无法获取远程版本号，请检查网络"
    exit 1
fi

VERSION_FILE="./docker/.zeroclaw_version"
LOCAL_VERSION=$(cat "$VERSION_FILE" 2>/dev/null || echo "")

# 比对并执行不同逻辑
if [ "$REMOTE_VERSION" == "$LOCAL_VERSION" ]; then
    echo "当前版本 ($LOCAL_VERSION) 已是最新，若配置改变重建容器"
    docker compose -p gateway -f "zeroclaw.yml" up -d
else
    echo "检测到新版本: $REMOTE_VERSION (本地: ${LOCAL_VERSION:-无})"

    # 下载与解压
    curl -L "${GITHUB_BASE}/releases/download/${REMOTE_VERSION}/zeroclaw-aarch64-unknown-linux-gnu.tar.gz" -o ./docker/zeroclaw-aarch64-unknown-linux-gnu.tar.gz
    mkdir -p ./docker/zeroclaw-aarch64
    tar -zxvf ./docker/zeroclaw-aarch64-unknown-linux-gnu.tar.gz -C ./docker/zeroclaw-aarch64

    # 构建
    docker build -t zeroclaw-debian:latest ./docker --network host \
    --build-arg HTTP_PROXY=http://127.0.0.1:7890 \
    --build-arg HTTPS_PROXY=http://127.0.0.1:7890

    # 清理并记录版本
    rm -rf ./docker/zeroclaw-aarch64*
    echo "$REMOTE_VERSION" > "$VERSION_FILE"

    # 启动/重建容器
    docker compose -p gateway -f "zeroclaw.yml" up -d
    echo "升级完成，当前版本: $REMOTE_VERSION"
fi

# 重启容器 应用配置
echo "同步配置文件 重启容器..."
LOCAL_DATA="/your/docker_data/zeroclaw"
cp ./docker/config.toml ${LOCAL_DATA}/.zeroclaw/
chown -R 65534:65534 ${LOCAL_DATA}/

docker compose -p gateway -f "zeroclaw.yml" restart