#!/bin/bash

# 确保以root用户运行
if [ "$EUID" -ne 0 ]; then
  echo "请以root用户运行此脚本！"
  exit 1
fi

# 1. 安装 ELRepo 仓库
echo "安装 ELRepo 仓库..."
rpm --import https://www.elrepo.org/RPM-GPG-KEY-elrepo.org
yum install -y https://www.elrepo.org/elrepo-release-7.el7.elrepo.noarch.rpm

# 2. 启用 ELRepo 的 kernel 仓库
echo "启用 ELRepo 的 kernel 仓库..."
yum-config-manager --enable elrepo-kernel

# 3. 安装内核 5.4
echo "安装内核 5.4..."
yum --enablerepo=elrepo-kernel install -y kernel-lt-5.4.275 kernel-lt-devel-5.4.275

# 4. 设置默认启动内核
echo "设置默认启动内核..."
grub2-set-default "$(awk -F\' '$1=="menuentry " {print i++ " : " $2}' /etc/grub2.cfg | grep '5.4.275' | cut -d':' -f1)"

# 5. 更新 GRUB 配置
echo "更新 GRUB 配置..."
grub2-mkconfig -o /boot/grub2/grub.cfg

# 6. 提示重启
echo "内核升级完成！请重启系统以应用新内核。"
echo "执行 'reboot' 重启系统。"
