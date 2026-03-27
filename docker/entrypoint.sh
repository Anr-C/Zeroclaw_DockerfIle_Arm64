#!/bin/bash

# 1. 定义清理函数，当脚本退出时尝试杀掉后台进程
cleanup() {
    echo "Stopping daemon..."
    kill $DAEMON_PID
    exit 0
}

# 捕获容器停止信号 (SIGTERM)
trap cleanup SIGTERM

# 2. 启动 daemon 并将其转入后台
export RUST_LOG=info
echo "Starting zeroclaw daemon on port 42618..."
zeroclaw daemon --host 0.0.0.0 --port 42618 2>&1 & DAEMON_PID=$!

# 3. 启动主进程 gateway
# 使用 exec 替换当前 shell 进程，使其成为 PID 1
echo "Starting zeroclaw gateway on port 42617..."
exec zeroclaw gateway