#!/bin/bash

log_error() {
    local error_message=$1
    local timestamp=$(date "+%Y-%m-%d %H:%M:%S")
    echo "$timestamp, $error_message" >> log.csv
}

if [[ "$role" == "Kullanıcı" ]]; then
    log_error "Bu işlemi gerçekleştirme yetkiniz yok!"
    zenity --error --text="Bu işlemi gerçekleştirme yetkiniz yok!"
    exit 1
fi


urun=$(zenity --entry --title="ürün güncelle" --text="güncellemek istediğiniz ürünün adını giriniz:")
if [[ -z "$urun" ]]; then
  log_error "ürün adı boş bırakılamaz."
  zenity --error --text="ürün adı boş bırakılamaz"
  exit
fi


satir=$(grep -i "^.*,$urun,.*$" depo.csv)
if [[ -z "$satir" ]]; then
  log_error "ürün bulunamadı" 
  zenity --error --text="ürün bulunamadı!"
  exit
fi


IFS="," read -r id ad stok fiyat kategori <<< "$satir"

yeni_stok=$(zenity --entry --title="stok güncelle" --text="yeni stok miktarını girin:" --entry-text="$stok")
yeni_fiyat=$(zenity --entry --title="fiyat güncelle" --text="yeni fiyatı girin:" --entry-text="$fiyat")

if [[ ! "$yeni_stok" =~ ^[0-9]+$ || ! "$yeni_fiyat" =~ ^[0-9]+(\.[0-9]{1,2})?$ ]]; then
  log_error " geçersiz giriş"
  zenity --error --text="geçersiz giriş"
  exit
fi

sed -i "/^$id,$ad,$stok,$fiyat,$kategori$/c\\$id,$ad,$yeni_stok,$yeni_fiyat$kategori" depo.csv
zenity --info --text="ürün başarıyla yüklendi"

