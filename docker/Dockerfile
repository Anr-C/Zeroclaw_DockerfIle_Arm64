FROM debian:trixie-slim AS runtime

# 清华源
RUN sed -i 's/deb.debian.org/mirrors.tuna.tsinghua.edu.cn/g' /etc/apt/sources.list.d/debian.sources

# Install essential tools for agent shell operations
RUN apt-get update && apt-get install -y --no-install-recommends \
        bash \
        ca-certificates \
        curl \
        git \
        unzip wget iputils-ping \
        python3 python3-pip build-essential \
    && rm -rf /var/lib/apt/lists/*

# Install uv and symlink to system path
RUN curl -LsSf https://astral.sh/uv/install.sh | sh && \
  ln -s /root/.local/bin/uv /usr/local/bin/uv && \
  ln -s /root/.local/bin/uvx /usr/local/bin/uvx && \
  uv --version

# 强制移除 python 外部环境管理限制，允许模型自由使用 pip
RUN rm -f /usr/lib/python3*/EXTERNALLY-MANAGED && ln -sf $(which python3) /usr/bin/python

# Copy binary 下载二进制文件放在当前目录
COPY ./zeroclaw-aarch64/zeroclaw /usr/local/bin/zeroclaw

# Environment setup
# Ensure UTF-8 locale so CJK / multibyte input is handled correctly
ENV LANG=C.UTF-8
ENV ZEROCLAW_WORKSPACE=/zeroclaw-data/workspace
ENV HOME=/zeroclaw-data
# Default provider and model are set in config.toml, not here,
# so config file edits are not silently overridden
ENV ZEROCLAW_GATEWAY_PORT=42617

# API_KEY must be provided at runtime!

# 同时启动 gateway 与 daemon
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

WORKDIR /zeroclaw-data
USER 65534:65534
EXPOSE 42617
EXPOSE 42618
HEALTHCHECK --interval=60s --timeout=10s --retries=3 --start-period=10s \
    CMD ["zeroclaw", "status", "--format=exit-code"]
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
