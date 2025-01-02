#!/bin/bash

log_error() {
    local error_message=$1
    local timestamp=$(date "+%Y-%m-%d %H:%M:%S")
    echo "$timestamp, $error_message" >> log.csv
}

# Kullanıcı ekleme
function add_user() {
    local username=$(zenity --entry --title="Yeni Kullanıcı Ekle" --text="Kullanıcı Adı:")
    local role=$(zenity --list --title="Kullanıcı Rolü" --radiolist --column="Seçim" --column="Rol" TRUE Yönetici FALSE Kullanıcı)
    local password=$(zenity --password --title="Şifre Belirleyin")
    
    if [[ -z "$username" || -z "$role" || -z "$password" ]]; then
        log_error "tüm alanlar doldurulmalıdır."
        zenity --error --text="Tüm alanlar doldurulmalıdır!"
        return
    fi

    local encrypted_password=$(echo -n "$password" | md5sum | awk '{print $1}')
    echo "$username,$role,$encrypted_password" >> kullanici.csv
    zenity --info --text="Kullanıcı başarıyla eklendi!"
}

# Kullanıcı listeleme
function list_users() {
    [[ ! -f kullanici.csv ]] && touch kullanici.csv
    zenity --text-info --title="Kullanıcı Listesi" --filename=kullanici.csv
}

# Kullanıcı güncelleme
function update_user() {
    local username=$(zenity --entry --title="Kullanıcı Güncelle" --text="Güncellenecek Kullanıcı Adı:")
    if ! grep -q "$username" kullanici.csv; then
        log_error "kullanici bulunamadi."
        zenity --error --text="Kullanıcı bulunamadı!"
        return
    fi

    local new_role=$(zenity --list --title="Yeni Rol Seçin" --radiolist --column="Seçim" --column="Rol" TRUE Yönetici FALSE Kullanıcı)
    sed -i "s/^$username,[^,]*,/$username,$new_role,/" kullanici.csv
    zenity --info --text="Kullanıcı başarıyla güncellendi!"
}

# Kullanıcı silme
function delete_user() {
    local username=$(zenity --entry --title="Kullanıcı Sil" --text="Silinecek Kullanıcı Adı:")
    if grep -q "$username" kullanici.csv; then
        sed -i "/^$username,/d" kullanici.csv
        zenity --info --text="Kullanıcı başarıyla silindi!"
    else
        log_error "kullanıcı bulunamadı"
        zenity --error --text="Kullanıcı bulunamadı!"
    fi
}

# Ana menü
while true; do
    action=$(zenity --list --title="Kullanıcı Yönetimi" --column="İşlem Seçin" \
        "Yeni Kullanıcı Ekle" "Kullanıcıları Listele" "Kullanıcı Güncelle" "Kullanıcı Sil" "Çıkış")
    case $action in
        "Yeni Kullanıcı Ekle") add_user ;;
        "Kullanıcıları Listele") list_users ;;
        "Kullanıcı Güncelle") update_user ;;
        "Kullanıcı Sil") delete_user ;;
        "Çıkış") break ;;
    esac
done
