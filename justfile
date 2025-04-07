set dotenv-load := true
set quiet := true

DOCKER_APP_SERVICE := "app"

env-addvar name value:
    cp --update=none .env.example .env || touch .env
    sed -i "/^{{name}}=/d" ".env"
    echo "{{name}}={{value}}" >> .env

wsl-add-env:
    #!/bin/sh
    HOST_IP=$(ip route show | grep -i default | awk '{ print $3}')
    just env-addvar ADB_SERVER_SOCKET "tcp:$HOST_IP:$ADB_PORT"

wsl-connect-adb:
    powershell.exe -Command "adb kill-server"
    powershell.exe -Command "adb -a -P $ADB_PORT start-server"

wsl-run-emulator:
    just wsl-connect-adb
    nohup powershell.exe -Command "emulator -avd $EMULATOR_NAME -no-snapshot" &

container-init:
    mkdir -p ./$PROJECT_DIR
    docker compose kill
    docker compose up -d --remove-orphans --build
    cp --update=none ./environment/{{DOCKER_APP_SERVICE}}/include/* ./$PROJECT_DIR

container-rebuild:
    just container-remove
    docker compose build --no-cache

container-start:
    docker compose up -d

container-stop:
    docker compose stop

container-remove:
    docker compose kill
    docker compose down -v --remove-orphans

container-exec *params:
    docker compose exec {{DOCKER_APP_SERVICE}} bash -c "{{params}}"

container-shell:
    just container-exec bash
