# Zeroclaw_DockerfIle_Arm64

## CN
通过 Docker 轻松运行 ZeroClaw；

🛠 准备工作

* 配置：编辑 config.toml，根据你的需求调整各项参数。

* 路径设置：查找所有出现的 /your/docker_data/ 路径（涉及 zeroclaw.yml 和 deploy.sh 文件），并将其替换为你实际的数据存储路径。

* 代理：确保你的代理服务运行在 7890 端口（构建参数 build-arg 需要用到）；或者从 deploy.sh 中移除相关代理配置。

🚀 执行以下命令开始运行：

```
chmod +x deploy.sh
./deploy.sh
```

功能特性：

* 支持 网关 (Gateway) 模式（附带 Web UI 界面）。

* 支持 守护进程 (Daemon) 模式，具备频道集成功能（例如 QQ 等）。

祝使用愉快！

## 关于版本

由于 v0.3.2 以上版本与 ollama 匹配度差，到至今 0.6x 已经无法使用，特提供 deploy-stable.sh 供研究学习体验。

## EN

Run ZeroClaw easily with Docker; 

🛠 Prepare

* Configure: Edit config.toml with your options.

* Path Setup: Find all instances of `/your/docker_data/` (zeroclaw.yml、deploy.sh) and replace them with your actual data path.

* Proxy: Ensure your proxy is running on port 7890 (required for build-arg) or remove them form `deploy.sh`. 

🚀 Run the following commands to start:

```
chmod +x deploy.sh
./deploy.sh
```

Features:

* Supports Gateway mode (with Web UI).

* Supports Daemon mode with channel integration (e.g., QQ, etc.).

Enjoy!