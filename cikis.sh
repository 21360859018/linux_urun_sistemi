#!/bin/bash

# Çıkış onayı penceresi
zenity --question --text="Çıkmak istediğinize emin misiniz?" --title="Çıkış Onayı"

# Kullanıcı evet derse
if [[ $? -eq 0 ]]; then
    zenity --info --text="Program sonlandırılıyor."
    pkill -f main_menu.sh  # main_menu.sh scriptini tamamen sonlandır
    exit 0
else
    zenity --info --text="Çıkış iptal edildi."
    exit 1
fi
