#!/bin/bash

form=4zenity --forms --title="yeni kullanıcı ekle" \
  --add-entry="kullanıcı adı" \
  --add-password="şifre" \
  --add-liste="rol" --list-values="yönetici|kullanıcı")

if [[ $? -eq 0 ]]; then
  IFS="|" read -r kullanici sifre rol <<< "$form"
  echo "$kullanici,$(echo -n "$sifre" | md5sum | cut -d' ' -f1),$rol"  >> kullanici.csv
  zenity --info --text="kullanici başarıyla eklendi!"
fi
