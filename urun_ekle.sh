#!/bin/bash


log_error() {
    local error_message=$1
    local timestamp=$(date "+%Y-%m-%d %H:%M:%S")
    echo "$timestamp, $error_message" >> log.csv
}


if [[ "$role" == "Kullanıcı" ]]; then
    zenity --error --text="Bu işlemi gerçekleştirme yetkiniz yok!"
    exit 1
fi


form=$(zenity --forms --title="Ürün ekle" \
  --add-entry="ürün adı" \
  --add-entry="stok miktarı" \
  --add-entry="birim fiyatı" \
  --add-entry="kategori")


if [[ $? -eq 0 ]]; then
  IFS="|" read -r ad stok fiyat kategori <<< "$form"
  if [[ -z "$ad" || -z "$stok" || -z "$fiyat" || -z "$kategori" ]] then
    log_error "Boş alan bırakılmamalıdır."
    zenity --error--text="boş alan bırakmayınız."
  elif [[ ! "$stok" =~ ^[0-9]+$ || ! "$fiyat" =~ ^[0-9]+(\.[0-9]{1,2})?$ ]]; then
    log_error "stok ve fiyat pozitif olmalıdır."
    zenity --error --text="stok ve fiyat pozitif olmalı"
    elif grep -q "^.*,$ad,.*" depo.csv; then
      log_error "Aynı isimde ürün zaten mevcut: $ad"
      zenity --error --text="Bu isimde bir ürün zaten mevcut. Ürün eklenemedi."
  else  
   id=$(( $(tail -n 1 depo.csv | cut -d',' -f1) + 1 ))
   echo "$id,$ad,$stok,$fiyat,$kategori" >> depo.csv
   zenity --info --text="ürün başarıyla eklendi!"
   fi
fi

