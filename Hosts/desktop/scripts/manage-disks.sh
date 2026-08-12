#!/usr/bin/env bash

# Цвета для вывода
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Список ваших дисков в формате "UUID:LABEL"
DISKS=(
  "5985a2f1-a9ab-4e9f-ae19-280685145e02:hdd4"
  "3b5448d2-3780-4cee-8529-caec12d1055e:hdd20"
  "fabfb454-6de2-412d-8bc7-b56a849c77c7:hdd24"
)

# Функция проверки статуса
get_status() {
  local label="$1"
  if mountpoint -q "/data/$label" 2>/dev/null; then
    echo -e "${GREEN}Смонтирован${NC}"
  elif [ -b "/dev/mapper/$label" ]; then
    echo -e "${YELLOW}Расшифрован, но не смонтирован${NC}"
  else
    echo -e "${RED}Заблокирован${NC}"
  fi
}

# Функция включения диска
mount_disk() {
  local uuid="$1"
  local label="$2"
  local mountDir="/data/$label"

  if mountpoint -q "$mountDir" 2>/dev/null; then
    echo "Диск $label уже смонтирован."
    return
  fi

  echo -e "\n--- Активация $label ---"
  sudo mkdir -p "$mountDir"

  if [ ! -b "/dev/mapper/$label" ]; then
    sudo cryptsetup luksOpen "/dev/disk/by-uuid/$uuid" "$label" || return 1
  fi

  sudo mount "/dev/mapper/$label" "$mountDir" && echo -e "${GREEN}$label успешно смонтирован в $mountDir${NC}"
}

# Функция выключения диска
umount_disk() {
  local label="$1"
  local mountDir="/data/$label"

  echo -e "\n--- Отключение $label ---"
  if mountpoint -q "$mountDir" 2>/dev/null; then
    sudo umount "$mountDir"
  fi

  if [ -b "/dev/mapper/$label" ]; then
    sudo cryptsetup luksClose "$label"
  fi
  echo -e "${RED}$label успешно закрыт${NC}"
}

# Меню
while true; do
  echo -e "\n======================================="
  echo "    ТЕСТ ПАНЕЛИ УПРАВЛЕНИЯ ДИСКАМИ     "
  echo "======================================="

  for i in "${!DISKS[@]}"; do
    IFS=":" read -r uuid label <<< "${DISKS[$i]}"
    status=$(get_status "$label")
    echo -e "[$i] $label \t (Статус: $status)"
  done
  echo "======================================="
  echo "[m] Смонтировать ВСЕ"
  echo "[u] Размонтировать ВСЕ"
  echo "[q] Выход"
  echo "---------------------------------------"

  read -p "Выберите номер диска или действие: " choice

  case "$choice" in
    q|Q)
      echo "Выход."
      break
      ;;
    m|M)
      for item in "${DISKS[@]}"; do
        IFS=":" read -r uuid label <<< "$item"
        mount_disk "$uuid" "$label"
      done
      ;;
    u|U)
      for item in "${DISKS[@]}"; do
        IFS=":" read -r uuid label <<< "$item"
        umount_disk "$label"
      done
      ;;
    [0-2])
      IFS=":" read -r uuid label <<< "${DISKS[$choice]}"
      if mountpoint -q "/data/$label" 2>/dev/null; then
        umount_disk "$label"
      else
        mount_disk "$uuid" "$label"
      fi
      ;;
    *)
      echo "Неверный выбор, попробуйте еще раз."
      ;;
  esac
done
