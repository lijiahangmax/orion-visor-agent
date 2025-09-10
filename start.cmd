@echo off
SETLOCAL

:: $${xxx} 为在系统安装时自动替换, 若不符合则可以手动替换
cd /d %~dp0

:: 检查并初始化 .key 文件
IF NOT EXIST ".key" (
    echo "Initializing agent (no .key found)..."
    instance_agent.exe init -k $${AGENT_KEY} .
    echo "Agent initialized."
) ELSE (
    echo ".key file found, skipping initialization."
)

:: 检查并停止已运行的 agent
IF EXIST ".pid" (
    echo "Stopping existing agent (.pid found)..."
    instance_agent.exe stop .
    echo "Agent stopped."
) ELSE (
    echo "No .pid file found, assuming agent not running."
)

:: 获取 agent 版本信息
echo "Agent version:"
instance_agent.exe version
echo.

:: 后台启动 agent
echo "Starting agent in background..."
START /B "" instance_agent.exe start . > nul 2>&1
echo "Agent started."
