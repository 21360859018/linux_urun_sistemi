#!/bin/bash

log_error() {
    local error_message=$1
    local timestamp=$(date "+%Y-%m-%d %H:%M:%S")
    echo "$timestamp, $error_message" >> log.csv   #zaman ve hata mesajını log.csv ye gönderiyor.
}


# Yönetici ve Kullanıcı Kontrol Fonksiyonu
function login() {
    role=$(zenity --list --title="Giriş Yap" --column="Rol Seçimi" "Yönetici" "Kullanıcı")
    case $role in
        "Yönetici")
            admin_login ;;
        "Kullanıcı")
            user_menu ;;
        *)
            log_error "geçersiz seçim yapıldı"
            zenity --error --text="Geçersiz seçim yapıldı!" ;;
    esac
}

# Yönetici Girişi
function admin_login() {
    username=$(zenity --entry --title="Yönetici Girişi" --text="Kullanıcı Adı:")
    password=$(zenity --password --title="Şifre:")
    encrypted_password=$(echo -n "$password" | md5sum | awk '{print $1}')
    #md5sum bir şifreleme algoritmasıdır.
    # Kullanıcı doğrulama
    if grep -q "^$username,Yönetici,$encrypted_password" kullanici.csv; then
        zenity --info --text="Yönetici girişi başarılı!"
        admin_menu
    else
        log_error "kullanici adi veya sifre hatali."
        zenity --error --text="Kullanıcı adı veya şifre hatalı!"
    fi
}

# Kullanıcı Menüsü
function user_menu() {
    while true; do
        action=$(zenity --list --title="Kullanıcı Menüsü" --column="İşlem Seçin" \
            "Ürün Listele" "Rapor Al" "Çıkış" --width=500 --height=400)
        case $action in
            "Ürün Listele") ./urun_listele.sh ;;
            "Rapor Al") ./rapor_al.sh ;;  # Raporlama işlemleri burada yer alacak
            "Çıkış") ./cikis.sh ;;
            *) zenity --error --text="Geçersiz seçim!" ;;
        esac
    done
}

# Yönetici Menüsü
function admin_menu() {
    while true; do
        action=$(zenity --list --title="Yönetici Menüsü" --column="İşlem Seçin" \
            "Ürün Ekle" "Ürün Güncelle" "Ürün Sil" "Program Yönetimi" "Kullanıcı Yönetimi" "Çıkış" --width=500 --height=400)
        case $action in
            "Ürün Ekle") ./urun_ekle.sh ;;
            "Ürün Güncelle") ./urun_guncelle.sh ;;
            "Ürün Sil") ./urun_sil.sh ;;
            "Program Yönetimi") ./program_yonetimi.sh ;; 
            "Kullanıcı Yönetimi") ./kullanici_yonetimi.sh ;;
            "Çıkış") ./cikis.sh ;;
            *) zenity --error --text="Geçersiz seçim!" ;;
        esac
    done
}

# Program Başlatma
login
