#!/bin/bash
set -e

echo ">>> FIX: Starting BusyBox replacement routine..."

# 1. Определяем путь к папке с BusyBox
BUSYBOX_DIR="padavan-ng/trunk/user/busybox"

# 2. Удаляем папку со сломанной версией 1.37.0
if [ -d "$BUSYBOX_DIR/busybox-1.37.0" ]; then
    echo ">>> FIX: Removing broken busybox-1.37.0..."
    rm -rf "$BUSYBOX_DIR/busybox-1.37.0"
fi

# 3. Клонируем стабильную версию 1.29.3 из репозитория dm38
#    Это самый надёжный способ получить рабочие исходники.
if [ ! -d "$BUSYBOX_DIR/busybox-1.29.3" ]; then
    echo ">>> FIX: Cloning stable busybox-1.29.3 from dm38 repository..."
    # Клонируем только нужную нам папку, чтобы сэкономить время и место
    git clone --depth 1 --branch master --filter=blob:none --sparse \
        https://gitlab.com/dm38/padavan-ng.git /tmp/padavan-ng-dm38
    cd /tmp/padavan-ng-dm38
    git sparse-checkout set trunk/user/busybox/busybox-1.29.3
    cd -
    # Копируем исходники в нужное место
    cp -r /tmp/padavan-ng-dm38/trunk/user/busybox/busybox-1.29.3 "$BUSYBOX_DIR/"
    # Убираем за собой временную папку
    rm -rf /tmp/padavan-ng-dm38
    echo ">>> FIX: Successfully copied busybox-1.29.3."
fi

# 4. Создаём символическую ссылку, чтобы сборщик использовал версию 1.29.3
#    Это финальный шаг, который "обманывает" систему сборки.
echo ">>> FIX: Creating symlink to force using busybox-1.29.3..."
cd "$BUSYBOX_DIR"
# Удаляем старую ссылку, если она есть
rm -f busybox-1.29.3
# Создаём новую ссылку на папку со стабильной версией
ln -sf busybox-1.29.3 busybox-1.29.3
cd - > /dev/null

echo ">>> FIX: Busybox replacement completed successfully."
