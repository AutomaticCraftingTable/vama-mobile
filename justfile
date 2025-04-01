set quiet := true

EMULATOR_NAME := "spoko"
ADB_PORT := "5037"
DOCKER_APP_SERVICE := "app"

run-host-emulator:
    powershell.exe -Command "emulator -avd {{EMULATOR_NAME}} -no-snapshot"

add-env-var name value:
    touch .env
    sed -i "/^{{name}}=/d" ".env"
    echo "{{name}}={{value}}" >> .env

wsl-create-env:
    #!/bin/sh
    POWERSHELL_LOCAL_IP_ADDRESSES="(Get-NetIPAddress -AddressFamily IPv4 -InterfaceAlias (Get-NetConnectionProfile | Select-Object -ExpandProperty InterfaceAlias)).IPAddress"
    HOST_IP=$(powershell.exe -Command $POWERSHELL_LOCAL_IP_ADDRESSES | grep "192.168" | tr -d '\r')
    just add-env-var ADB_SERVER_SOCKET "tcp:$HOST_IP:{{ADB_PORT}}"

wsl-connect-adb:
    powershell.exe -Command "adb kill-server; adb -a -P {{ADB_PORT}} start-server"

dexec param:
    docker compose exec {{DOCKER_APP_SERVICE}} sh -c "{{param}}"

init:
    docker compose kill
    docker compose up -d --remove-orphans --build
    just dexec "sh ./environment/app/init.sh"

rebuild:
    just remove
    docker compose build --no-cache

start:
    docker compose up -d

stop:
    docker compose stop

remove:
    docker compose kill
    docker compose down -v --remove-orphans

dev:
    just dexec "flutter run" > /dev/null 2>&1 &

dshell:
    just dexec "bash"
