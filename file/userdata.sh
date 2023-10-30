#!/bin/bash

# パッケージインストール
sudo yum install -y rpm-build make git python3
sudo git clone https://github.com/aws/aws-ec2-instance-connect-config.git
cd aws-ec2-instance-connect-config
sudo make rpm
sudo rpm -ivh rpmbuild/RPMS/noarch/ec2-instance-connect-1.1-18.noarch.rpm

# sshdの設定変更
sudo echo -e '\n# EC2 Instance Connect configuration\nAuthorizedKeysCommand /opt/aws/bin/eic_run_authorized_keys %u %f\nAuthorizedKeysCommandUser ec2-instance-connect' | sudo tee -a /etc/ssh/sshd_config
sudo systemctl restart sshd

# SELINUXの設定変更
sudo sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/selinux/config

# 再起動
sudo shutdown -r now