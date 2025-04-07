# VAMA - mobile
Klient mobilny projektu VAMA
## Konfiguracja lokalnego rozwoju
### Instalacja zależności:
- Należy zainstalować `just`
- Należy zainstalować `docker`
#### Instalacja `just` w systemie z menedżerem pakietów `snap`:
```sh
sudo snap install just --classic
```
### Inicjalizacja konteneru:
#### WSL
```sh
cp .env.example .env
just wsl-add-env
just container-init
```
#### Linux / WSL with network mirroring (Windows 11 only)
```sh
cp .env.example .env
just container-init
```

### Inicjalizacja emulatora:

#### Linux
```
just run-emulator
```
#### WSL
Dla WSL należy uruchomić emulator zainstalowany na maszynie z systemem Windows, aby uzyskać najlepszą wydajność.

- Należy ustawić nazwę swojego emulatora w pliku .env

- Następnie uruchomić:
    ```sh
    just wsl-run-emulator
    ```

### Rozwój w devcontainerze (VS Code)
Aby uzyskać linting Flutera w VS Code, należy:
- Zainstalować rozszerzenie devcontainers
- `Ctrl` + `Shift` + `P` -> "Dev Containers: Reopen in Containier"
