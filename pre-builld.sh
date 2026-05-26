#!/bin/bash

# Отключаем сборку сломанного busybox 1.37.0
echo ">>> FIX: Force using busybox 1.29.3"
# Удаляем исходники проблемной версии
rm -rf trunk/user/busybox/busybox-1.37.0
# Заменяем их на исходники стабильной версии 1.29.3
git checkout origin/master -- trunk/user/busybox
