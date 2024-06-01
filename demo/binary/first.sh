#!/bin/bash

# Отримати шлях до папки, в якій розташований скрипт
script_dir=$(dirname "$0")

# Отримати поточну дату та час
current_date=$(date +"%Y-%m-%d")
current_time=$(date +"%H:%M:%S")

# Отримати список зареєстрованих користувачів
user_list=$(cut -d: -f1 /etc/passwd)

# Отримати uptime системи
uptime=$(uptime)

# Вивести інформацію
echo "Дата: $current_date"
echo "Час: $current_time"
echo "Список зареєстрованих користувачів:"
echo "$user_list"
echo "Uptime системи:"
echo "$uptime"

# Зберегти інформацію у файл у тій же папці
log_file="$script_dir/system_info.log"
echo "Дата: $current_date" >> "$log_file"
echo "Час: $current_time" >> "$log_file"
echo "Список зареєстрованих користувачів:" >> "$log_file"
echo "$user_list" >> "$log_file"
echo "Uptime системи:" >> "$log_file"
echo "$uptime" >> "$log_file"

echo "Інформацію збережено у файлі: $log_file"
