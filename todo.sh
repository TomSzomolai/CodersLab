#!/bin/bash
# TODO app - COdersLab/kurz linux administratora
# ukládá se do = ~/.todo/todo.txt
# zálohy v = ~/.todo/backups při ukončení

# Umístění dat
DATA_DIR="$HOME/.todo"
TODO_FILE="$DATA_DIR/todo.txt"
BACKUP_DIR="$DATA_DIR/backups"

# Screen clear
cls() {
    if command -v tput >/dev/null 2>&1 && tput clear >/dev/null 2>&1; then
        tput clear
    elif command -v clear >/dev/null 2>&1; then
        clear
    else
        i=0; while [ $i -lt 50 ]; do echo ""; i=$((i+1)); done
    fi
}

# Příprava složek a souboru
init_storage() {
    mkdir -p "$DATA_DIR" >/dev/null 2>&1
    mkdir -p "$BACKUP_DIR" >/dev/null 2>&1
    [ -f "$TODO_FILE" ] || : > "$TODO_FILE"
}

# backup s časovým razítkem
make_backup() {
    local ts
    ts=$(date '+%Y%m%d-%H%M%S')
    cp "$TODO_FILE" "$BACKUP_DIR/todo-$ts.txt" 2>/dev/null
}

# Počet úkolů
tasks_count() {
    wc -l < "$TODO_FILE"
}

# Kontrola aplikačního indexu (1-n, dle operace)
valid_index() {
    local n idx
    n=$(tasks_count)
    idx="$1"
    [[ "$idx" =~ ^[0-9]+$ ]] || return 1     # číslo?
    (( idx >= 1 && idx <= n )) || return 1   # rozsah?
    return 0
}

# UI appky
show_menu() {
    echo "========================="
    echo "     TODO List Manager"
    echo "========================="
    echo "Soubory:"
    echo " - úkoly : $TODO_FILE"
    echo " - zálohy: $BACKUP_DIR"
    echo ""
    echo "1) Přidat úkol"
    echo "2) Zobrazit úkoly"
    echo "3) Označit jako hotový"
    echo "4) Smazat úkol"
    echo "5) Konec (uloží a zazálohuje)"
    printf "Vyber možnost (1-5): "
}

# funkce pro přidání úkolu
add_task() {
    cls
    echo "Zadej nový úkol:"
    read -r ukol
    if [ -n "$ukol" ]; then
        printf "[PENDING] %s (Added: %s)\n" "$ukol" "$(date '+%Y-%m-%d %H:%M')" >> "$TODO_FILE"
        echo "Úkol přidán."
    else
        echo "Úkol nemůže být prázdný."
    fi
    sleep 1
}

#funkce pro zobrazení úkolů
view_tasks() {
    cls
    if [ ! -s "$TODO_FILE" ]; then
        echo "Žádné úkoly."
    else
        nl -w2 -s". " "$TODO_FILE"
        echo ""
        local celkem hotovo cekajici
        celkem=$(tasks_count)
        hotovo=$(grep -c '\[COMPLETED\]' "$TODO_FILE" 2>/dev/null); hotovo=${hotovo:-0}
        cekajici=$((celkem - hotovo))
        echo "Celkem: $celkem  (Čeká: $cekajici, Hotovo: $hotovo)"
    fi
    echo ""
    read -r -p "Stiskni Enter pro návrat do menu..." _
}

# funkce pro změnu stavů úkolů
complete_task() {
    cls
    if [ ! -s "$TODO_FILE" ]; then
        echo "Žádné úkoly."
        sleep 1; return
    fi

    echo "Úkoly:"
    nl -w2 -s". " "$TODO_FILE"
    printf "Číslo úkolu k označení: "
    read -r cislo

    if valid_index "$cislo"; then
        local radek novy
        radek=$(sed -n "${cislo}p" "$TODO_FILE")
        if [[ "$radek" == *"[PENDING]"* ]]; then
            novy="${radek/\[PENDING\]/[COMPLETED]} - Completed: $(date '+%Y-%m-%d %H:%M')"
            # Bezpečné přepsání celého řádku (použijeme jiný oddělovač než /)
            sed -i "${cislo}s#.*#${novy}#" "$TODO_FILE"
            echo "Označeno jako hotové."
        else
            echo "Úkol už je hotový."
        fi
    else
        echo "Neplatné číslo nebo mimo rozsah."
    fi
    sleep 1
}

#funkce pro odstranění úkolů
delete_task() {
    cls
    if [ ! -s "$TODO_FILE" ]; then
        echo "Žádné úkoly."
        sleep 1; return
    fi

    echo "Úkoly:"
    nl -w2 -s". " "$TODO_FILE"
    printf "Číslo úkolu ke smazání: "
    read -r cislo

    if valid_index "$cislo"; then
        read -r -p "Opravdu smazat? (y/N): " potvrzeni
        if [[ "$potvrzeni" =~ ^[Yy]$ ]]; then
            sed -i "${cislo}d" "$TODO_FILE"
            echo "Úkol smazán."
        else
            echo "Zrušeno."
        fi
    else
        echo "Neplatné číslo nebo mimo rozsah."
    fi
    sleep 1
}

# smyčka
init_storage

while true; do
    cls
    show_menu
    read -r volba
    case "$volba" in
        1) add_task ;;
        2) view_tasks ;;
        3) complete_task ;;
        4) delete_task ;;
        5)
            echo "Ukládám a zálohuji..."
            make_backup
            echo "Hotovo. Ahoj."
            exit 0
            ;;
        *) echo "Neplatná volba."; sleep 1 ;;
    esac
done

