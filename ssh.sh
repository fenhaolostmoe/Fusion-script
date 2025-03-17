#!/bin/bash

# ssh服务端配置优化（需root权限）
echo "[*] 正在优化服务端配置..."
sudo cp /etc/ssh/sshd_config /etc/ssh/sshd_config.bak  # 备份
sudo sed -i 's/^#*UseDNS.*/UseDNS no/' /etc/ssh/sshd_config
sudo sed -i 's/^#*GSSAPIAuthentication.*/GSSAPIAuthentication no/' /etc/ssh/sshd_config
sudo sed -i 's/^hosts:.*/hosts: files dns/' /etc/nsswitch.conf  # 避免外网解析问题
sudo systemctl restart sshd
echo "[√] 服务端配置完成！"

# 客户端配置优化
echo "[*] 正在优化客户端配置..."
mkdir -p ~/.ssh
echo -e "Host *\n  ServerAliveInterval 60\n  ServerAliveCountMax 3" >> ~/.ssh/config
echo "[√] 客户端心跳配置完成！"
