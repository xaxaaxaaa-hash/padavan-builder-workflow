#!/bin/bash
set -e

echo ">>> FIX: Replacing broken busybox 1.37.0 with stable 1.29.3"

# Удаляем проблемную версию
rm -rf trunk/user/busybox/busybox-1.37.0

# Скачиваем стабильную версию из репозитория
cd trunk/user/busybox
wget https://gitlab.com/dm38/padavan-ng/-/raw/master/trunk/user/busybox/busybox-1.29.3.tar.bz2
tar -xjf busybox-1.29.3.tar.bz2
ln -sf busybox-1.29.3 busybox-1.29.3
rm -f busybox-1.29.3.tar.bz2
cd ../../..

echo ">>> FIX: Busybox replaced successfully"
