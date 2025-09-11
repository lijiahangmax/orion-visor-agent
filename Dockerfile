FROM --platform=$TARGETPLATFORM ubuntu:22.04

USER root

WORKDIR /instance-agent

# 设置时区
RUN sed -i 's@archive.ubuntu.com@mirrors.tuna.tsinghua.edu.cn@g' /etc/apt/sources.list && \
    sed -i 's@security.ubuntu.com@mirrors.tuna.tsinghua.edu.cn@g' /etc/apt/sources.list && \
    apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y tzdata && \
    ln -snf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && \
    echo "Asia/Shanghai" > /etc/timezone && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# 添加 agent
COPY ./instance_agent_linux_amd64 .
COPY ./instance_agent_linux_arm64 .
COPY ./config.yaml .

# 复制启动脚本并赋权
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
