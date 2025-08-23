# TODO List Manager (Bash)

Jednoduchý nástroj do příkazové řádky pro správu osobních úkolů. Umožňuje úkoly **přidávat**, **zobrazit**, **označit jako hotové** a **mazat**. Seznam je perzistentní mezi spuštěními a při ukončení se vytvoří **záloha**.

> Nástroj je záměrně napsaný „začátečnicky“ (funkce, `read`, cyklus `while`, `case`, práce se soubory). Odpovídá tématům z kurzu – interakce s uživatelem, práce se soubory a adresáři, základy grep/sed. (viz prezentace *Advanced Techniques in Bash* – User Interaction str. 3–6; Creating & Managing Directories str. 13–17; Writing to Files str. 15) :contentReference[oaicite:3]{index=3}

---

## Instalace (Ubuntu)

```bash
# 1) Ulož soubor jako todo.sh
    chmod +x todo.sh

# 2) Spuštění
    ./todo.sh


#pro instalaci přímo do path
    sudo install -m 0755 todo.sh /usr/local/bin/todo
    todo

## kde se nacházejí data?
    ls -la ~/.todo
    ls -la ~/.todo/backups

## odinstalace TODO
    rm -f ~/.todo/todo.txt
    rm -rf ~/.todo/backups

  # pokud bylo nainstalováno do /usr/local/bin
    sudo rm -f /usr/local/bin/todo
    



