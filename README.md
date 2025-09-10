## orion-visor-agent 实例监控探针

## 简介

`orion-visor-agent` 是一个由 **Go 语言** 开发的轻量级系统监控探针, 能够实时收集并上报系统指标数据到 **orion-visor**。它支持多种操作系统, 包括 **Linux、Windows 和
Darwin**, 并支持多种架构, 包括 **amd64 和 arm64**。该项目为 **闭源项目**。

## 通信方式

* 指标与心跳数据通过 **HTTP 主动上报** 给 `orion-visor`。(1min)

## 项目文档

* [文档地址](https://visor.orionsec.cn/agent/install.html)
* [更新日志](https://visor.orionsec.cn/agent/change-log.html)
* [常见问题](https://visor.orionsec.cn/agent/faq.html)

## 发布地址

可从以下地址下载发布包。如果 GitHub 下载失败, 可以尝试使用 Gitee 镜像：

* [GitHub 最新发布版本](https://github.com/lijiahangmax/orion-visor-agent/releases/latest/download/instance-agent-release.tar.gz)
* [GitHub 主分支直链](https://github.com/lijiahangmax/orion-visor-agent/raw/main/instance-agent-release.tar.gz)
* [Gitee 主分支直链](https://gitee.com/lijiahangmax/orion-visor-agent/raw/main/instance-agent-release.tar.gz)

## 全部命令

**instance_agent [command] [flags] [上下文目录]**

```bash
# 查看版本
./instance_agent version

# 初始化探针
./instance_agent init -k <系统的AgentKey> .
  -k | --key   系统的 AgentKey

# 启动探针
./instance_agent start .

# 停止探针
./instance_agent stop -kf .
  -k | --kill   发送 kill 信号
  -f | --force  强制停止此 pid
```

## 目录结构

```bash
/root/orion/orion-visor/instance-agent/
├── config.yaml           # 配置文件
├── instance_agent        # 探针可执行文件 (Linux / macOS) 
├── instance_agent.exe    # 探针可执行文件 (Windows)
├── start.sh              # 启动脚本 (Linux / macOS)
├── start.cmd             # 启动脚本 (Windows)
├── .pid                  # 当前运行进程的 PID (启动时生成)
├── .key                  # 探针的 AgentKey (init 时生成)
├── logs/                 # 日志目录
```

## 配置说明

```yaml
# 服务端设置
server:
  # 服务端地址 需要修改
  url: http://$${SERVER_HOST}:9200/orion-visor/api
  # 服务端 token 需要修改
  token: $${SERVER_TOKEN}

# 日志设置
zap:
  # 日志文件路径 ${home} 为家目录, ${context} 为上下文目录
  path: ${context}/logs
```

## 手动启动 (Linux/Darwin)

```bash
# 1. 创建文件夹
mkdir -p ${home}/orion/orion-visor/instance-agent
cd ${home}/orion/orion-visor/instance-agent
# 2. 解压缩发布包
tar -zxvf instance-agent-release.tar.gz
# 3. 修改配置文件
vim config.yaml 
# 4. 修改 start.sh 中的参数
vim start.sh
# 4. 重命名对应的启动文件 
mv instance_agent_<os>_<arch> instance_agent
# 5. 提权
chmod +x ./start.sh
# 6. 启动探针
./start.sh
# 7. 查看日志
tail -f logs/app.log
```

## 手动启动 (Windows)

windows 因为平台限制, 不支持自动安装。手动安装流程同上
