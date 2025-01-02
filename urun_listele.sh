#!/bin/bash

log_error() {
    local error_message=$1
    local timestamp=$(date "+%Y-%m-%d %H:%M:%S")
    echo "$timestamp, $error_message" >> log.csv
}


if [[ -s depo.csv ]]; then
  zenity --text-info --title="ürün listesi" --filename=depo.csv
else
  log_error "depo boş"
  zenity --info --text="depo şu anda boş"
fi
