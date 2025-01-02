#!/bin/bash

log_error() {
    local error_message=$1
    local timestamp=$(date "+%Y-%m-%d %H:%M:%S")
    echo "$timestamp, $error_message" >> log.csv
}


# Disk alanı gösterimi
function show_disk_space() {
    local disk_usage=$(df -h . | awk 'NR==2 {print $4}')
    zenity --info --text="Diskteki kullanılabilir alan: $disk_usage"
}

# Yedekleme işlemi
function backup_data() {
    local backup_dir="yedekler"
    mkdir -p "$backup_dir"
    cp depo.csv kullanici.csv "$backup_dir"
    zenity --info --text="Veriler başarıyla yedeklendi!"
}

# Hata kayıtlarını gösterme
function show_logs() {
    [[ ! -f log.csv ]] && touch log.csv
    zenity --text-info --title="Hata Kayıtları" --filename=log.csv
}

# Ana menü
while true; do
    action=$(zenity --list --title="Program Yönetimi" --column="İşlem Seçin" \
        "Disk Alanını Göster" "Verileri Yedekle" "Hata Kayıtlarını Göster" "Çıkış")
    case $action in
        "Disk Alanını Göster") show_disk_space ;;
        "Verileri Yedekle") backup_data ;;
        "Hata Kayıtlarını Göster") show_logs ;;
        "Çıkış") break ;;
    esac
done
