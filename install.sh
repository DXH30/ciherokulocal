#!/bin/bash
# Membaca file konfigurasi
i=0
file="./application/config/database.php"
function baca() {
    while IFS= read -r line
    do
        i=$((i + 1))
        echo "$line" $i
    done < $file
}
# Menghilangkan tanda # di antara BEGIN LOCAL dan END LOCAL
function ceklocal() {
    beginlocal=$(awk '/BEGIN LOCAL/ {print FNR}' $file)
    endlocal=$(awk '/END LOCAL/ {print FNR}' $file)
    if [[ $beginlocal == "" ]] && [[ $endlocal == "" ]]; then
        echo ""
    fi
    r1=$(($beginlocal + 1))
    r2=$(($endlocal - 1))
    echo "$r1" "$r2"
}
# Menghilangkan tanda # di antara BEGIN HEROKU dan END HEROKU
function cekheroku() {
    beginheroku=$(awk '/BEGIN HEROKU/ {print FNR}' $file)
    endheroku=$(awk '/END HEROKU/ {print FNR}' $file)
    if [[ $beginheroku == "" ]] && [[ $endheroku == "" ]]; then
        echo ""
    fi
    r1=$(($beginheroku + 1))
    r2=$(($endheroku - 1))
    echo "$r1" "$r2"
}

function notfound() {
    echo $i": Perintah tidak ditemukan"
    echo "Ketikkan h untuk melihat petunjuk"
}

function init() {
    echo "+=================================+"
    echo "|Author : Didik HS                |"
    echo "|Title  : Local Heroku Switcher DB|"
    echo "|Date   : 21 November 2019        |"
    echo "|License: GPLv2                   |"
    echo "+=================================+"
    echo "Ketikkan h untuk melihat petunjuk"
}

function petunjuk() {
    echo "h2l : mengubah konfig ke local"
    echo "l2h : mengubah konfig ke heroku"
    echo "i   : melihat init"
    echo "q   : keluar"
}

function herokutolocal() {
    line=$(head -n 1 status)
    read l1 l2 < <(ceklocal)
    read h1 h2 < <(cekheroku)
    printf "L1 : %s L2 : %s\n" "$l1" "$l2"
    printf "H1 : %s H2 : %s\n" "$h1" "$h2"
    if [[ $line == "heroku" ]]; then
        echo "Status : Heroku"
        echo "Mengubah menjadi local..."
        sed -i "$l1,$l2{s/^#//g}" $file
        sed -i "$h1,$h2{s/^/#/g}" $file
        echo "local" > status
    elif [[ $line == "local" ]]; then
        echo "Status anda sudah Local"
    else
        echo "Status tidak boleh selain local atau heroku"
        echo "echo local > status : untuk status jadi local"
        echo "echo heroku > status : untuk status jadi heroku"
    fi
}

function localtoheroku() {
    line=$(head -n 1 status)
    read l1 l2 < <(ceklocal)
    read h1 h2 < <(cekheroku)
    printf "L1 : %s L2 : %s\n" "$l1" "$l2"
    printf "H1 : %s H2 : %s\n" "$h1" "$h2"
    if [[ $line == "heroku" ]]; then
        echo "Status anda sudah heroku"
    elif [[ $line == "local" ]]; then
        echo "Status : Local"
        echo "Mengubah menjadi heroku..."
        sed -i "$h1,$h2{s/^#//g}" $file
        sed -i "$l1,$l2{s/^/#/g}" $file
        echo "heroku" > status
    else
        echo "Status tidak boleh selain local atau heroku"
        echo "echo local > status : untuk status jadi local"
        echo "echo heroku > status : untuk status jadi heroku"
    fi
}

function interpret() {
    while true
    do
        interpreter="> "
        printf "%s " $interpreter
        read command
        if [[ $command == "h" ]]; then
            petunjuk
        elif [[ $command == "i" ]]; then
            init
        elif [[ $command == "q" ]]; then
            break
        elif [[ $command == "h2l" ]]; then
            herokutolocal
        elif [[ $command == "l2h" ]]; then
            localtoheroku
        else
            notfound
        fi
    done
}

if [[ $# -lt 1 ]]; then
    echo "Penggunaan Inline : $0 command"
    echo "Dimana command adalah : "
    petunjuk
    init
    interpret
else
    if [[ $1 == "h" ]]; then
        petunjuk
    elif [[ $1 == "i" ]]; then
        init
    elif [[ $1 == "q" ]]; then
        echo "Keluar ?.."
    elif [[ $1 == "h2l" ]]; then
        herokutolocal
    elif [[ $1 == "l2h" ]]; then
        localtoheroku
    else
        notfound
    fi
fi
