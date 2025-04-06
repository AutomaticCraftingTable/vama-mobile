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
Not implemented yet
#### WSL
For WSL you'd have to run the emulator installed on your windows machine, for the best performance.

- Set the name of your emulator in `.env` file

- Then run:
    ```sh
    just wsl-run-emulator
    ```

### Development in a devcontainer (VS Code)
In order to get flutter's linting in VS Code, you'd have to:
- Install the `devcontainers` extension
- `Ctrl` + `Shift` + `P` -> "Dev Containers: Reopen in Containier"

This is not the best approach, since you can't open the terminal of your host from the contanier (unless you use SSH).