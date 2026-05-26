#!/bin/bash
set -e

echo ">>> FIX: Starting BusyBox replacement routine..."

# 1. Определяем путь к папке с BusyBox
BUSYBOX_DIR="trunk/user/busybox"

# 2. Удаляем папку со сломанной версией 1.37.0
if [ -d "$BUSYBOX_DIR/busybox-1.37.0" ]; then
    echo ">>> FIX: Removing broken busybox-1.37.0..."
    rm -rf "$BUSYBOX_DIR/busybox-1.37.0"
fi

# 3. Проверяем, есть ли уже версия 1.29.3
if [ ! -d "$BUSYBOX_DIR/busybox-1.29.3" ]; then
    echo ">>> FIX: Downloading stable busybox-1.29.3 directly..."
    # Скачиваем архив напрямую (самый надёжный способ)
    cd "$BUSYBOX_DIR"
    wget https://gitlab.com/dm38/padavan-ng/-/archive/master/padavan-ng-master.tar.bz2
    tar -xjf padavan-ng-master.tar.bz2
    # Копируем только нужную папку
    cp -r padavan-ng-master/trunk/user/busybox/busybox-1.29.3 .
    rm -rf padavan-ng-master.tar.bz2 padavan-ng-master
    cd ../..
    echo ">>> FIX: Successfully downloaded and copied busybox-1.29.3."
fi

# 4. Создаём символическую ссылку
echo ">>> FIX: Creating symlink to force using busybox-1.29.3..."
cd "$BUSYBOX_DIR"
rm -f busybox-1.37.0
ln -sf busybox-1.29.3 busybox-1.37.0
cd - > /dev/null

echo ">>> FIX: Busybox replacement completed successfully."
