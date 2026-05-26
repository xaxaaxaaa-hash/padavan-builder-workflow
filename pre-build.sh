#!/bin/bash
set -e

echo ">>> FIX: Starting BusyBox replacement routine..."

# Ждём, пока появятся исходники (максимум 60 секунд)
for i in {1..60}; do
    if [ -d "trunk/user/busybox" ]; then
        break
    fi
    sleep 1
done

# Проверяем, что папка существует
if [ ! -d "trunk/user/busybox" ]; then
    echo ">>> ERROR: trunk/user/busybox not found after waiting"
    exit 1
fi

BUSYBOX_DIR="trunk/user/busybox"

# Удаляем сломанную версию
if [ -d "$BUSYBOX_DIR/busybox-1.37.0" ]; then
    echo ">>> FIX: Removing broken busybox-1.37.0..."
    rm -rf "$BUSYBOX_DIR/busybox-1.37.0"
fi

# Скачиваем стабильную версию, если её нет
if [ ! -d "$BUSYBOX_DIR/busybox-1.29.3" ]; then
    echo ">>> FIX: Downloading stable busybox-1.29.3..."
    cd "$BUSYBOX_DIR"
    wget -q https://gitlab.com/dm38/padavan-ng/-/archive/master/padavan-ng-master.tar.bz2
    tar -xjf padavan-ng-master.tar.bz2 2>/dev/null
    cp -r padavan-ng-master/trunk/user/busybox/busybox-1.29.3 . 2>/dev/null
    rm -rf padavan-ng-master.tar.bz2 padavan-ng-master
    cd ../..
    echo ">>> FIX: Successfully downloaded busybox-1.29.3"
fi

# Создаём ссылку, обманывая сборщик
cd "$BUSYBOX_DIR"
rm -f busybox-1.37.0
ln -sf busybox-1.29.3 busybox-1.37.0
cd - > /dev/null

echo ">>> FIX: Busybox replacement completed successfully"
