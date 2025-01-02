#!/bin/bash

log_error() {
    local error_message=$1
    local timestamp=$(date "+%Y-%m-%d %H:%M:%S")
    echo "$timestamp, $error_message" >> log.csv
}

if [[ "$role" == "Kullanıcı" ]]; then
    log_error "bu işlemi gerçekleştirme yetkiniz yok."
    zenity --error --text="Bu işlemi gerçekleştirme yetkiniz yok!"
    exit 1
fi


urun=$(zenity --entry --title="ürün sil" --text="silmek istediğiniz ürünün adını girin:")

if [[ -z "$urun" ]]; then
  log_error " ürün adı boş bırakılamaz."
  zenity --error --text="ürün adı boş bırakılamaz!"
  exit
fi


satir=$(grep -i "^.*,$urun,.*$" depo.csv)
 
if [[ -z "$satir" ]]; then
  log_error "ürün bulunamadı"
  zenity --error --text="ürün bulunamadı!"
  exit
fi

zenity --question --title="ürün silme onayı" --text="bu ürünü silmek istediğinize emin misiniz?\n\n$satir"

if [[ $? -eq 0 ]]; then
  sed -i "/^.*,$urun,.*$/d" depo.csv
  zenity --info --text="ürün başarıyla silindi"
else
  zenity --info --text="ürün silme iptal edildi"
fi
