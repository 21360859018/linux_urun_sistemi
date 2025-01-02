#!/bin/bash

# Stokta azalan ürünler raporu
function low_stock_report() {
    threshold=$(zenity --entry --title="Eşik Değeri" --text="Stok alt sınırı girin:")
    awk -F ',' -v limit="$threshold" '$3 < limit {print $0}' depo.csv | zenity --text-info --title="Stok Azalan Ürünler"
}

# En yüksek stok miktarına sahip ürünler raporu
function high_stock_report() {
    threshold=$(zenity --entry --title="Eşik Değeri" --text="Stok üst sınırı girin:")
    awk -F ',' -v limit="$threshold" '$3 > limit {print $0}' depo.csv | zenity --text-info --title="En Yüksek Stoklu Ürünler"
}

# Ana Menü
while true; do
    action=$(zenity --list --title="Raporlama Menüsü" --column="İşlem Seçin" \
        "Stok Azalan Ürünler" "En Yüksek Stoklu Ürünler" "Çıkış")
    case $action in
        "Stok Azalan Ürünler") low_stock_report ;;
        "En Yüksek Stoklu Ürünler") high_stock_report ;;
        "Çıkış") break ;;
        *) zenity --error --text="Geçersiz seçim!" ;;
     esac
done
