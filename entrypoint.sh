#!/bin/sh
set -e

# 获取系统架构
ARCH=$(uname -m)
case "$ARCH" in
    x86_64)
        BIN="instance_agent_linux_amd64"
        ;;
    aarch64)
        BIN="instance_agent_linux_arm64"
        ;;
    *)
        echo "❌ Unsupported architecture: $ARCH"
        exit 1
        ;;
esac

# 替换 config.yaml 中的 URL
if [ -n "$SERVER_API" ]; then
    sed -i "s|^  url:.*|  url: ${SERVER_API}|" config.yaml
fi

# 替换 SERVER_TOKEN
if [ -n "$SERVER_TOKEN" ]; then
    sed -i "s|\$\${SERVER_TOKEN}|${SERVER_TOKEN}|g" config.yaml
fi

# 使用 cp 保留原始二进制
cp "$BIN" instance_agent
chmod +x ./instance_agent

# 初始化（仅当 .key 文件不存在时）
if [ ! -f ".key" ]; then
    if [ -n "$AGENT_KEY" ]; then
        echo "No .key file found, initializing agent..."
        ./instance_agent init -k "${AGENT_KEY}" .
    fi
fi

# 获取 agent 版本
echo "Agent version:"
./instance_agent version || true

# 启动 agent
echo "Starting agent..."
exec ./instance_agent start .
