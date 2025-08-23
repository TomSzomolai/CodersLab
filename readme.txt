# TODO List Manager (Bash)

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
    



