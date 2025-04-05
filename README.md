# VAMA - mobile
Klient mobilny projektu VAMA
## Konfiguracja aplikacji
### Instalacja zależności:
- Należy zainstalować `just`
- Należy zainstalować `docker`
#### Instalacja `just` w systemie z menedżerem pakietów snap:
```sh
sudo snap install just --classic
```
### Inicjalizacja projektu:

#### Linux
```sh
cp .env.example .env
```

#### WSL
```sh
cp .env.example .env
```

## Komendy
#### Aby zatrzymać kontener:
```sh
just stop
```
#### Jeśli już zainicjalizowałeś projekt i chcesz tylko uruchomić kontener:
```sh
just start
```