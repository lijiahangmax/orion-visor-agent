#!/bin/sh

set -e

# $${xxx} 为在系统安装时自动替换, 若不符合则可以手动替换

# 确保 ./instance_agent 可执行
if [ ! -x "./instance_agent" ]; then
  chmod +x ./instance_agent
fi

# 检查并初始化 .key
if [ ! -f ".key" ]; then
  echo "Initializing agent (no .key found)..."
  ./instance_agent init -k $${AGENT_KEY} .
  echo "Agent initialized."
fi

# 检查并停止已运行的 agent
if [ -f ".pid" ]; then
  echo "Stopping existing agent (.pid found)..."
  ./instance_agent stop .
  echo "Agent stopped."
fi

# 获取 agent 版本
echo "Agent version:"
./instance_agent version
echo

# 后台启动 agent
echo "Starting agent in background..."
nohup ./instance_agent start . > /dev/null 2>&1 &
echo "Agent started."
