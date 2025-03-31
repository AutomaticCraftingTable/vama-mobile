set quiet

DOCKER_APP_SERVICE := "app"

dexec params:
    docker compose exec {{DOCKER_APP_SERVICE}} sh -c "{{params}}"

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
    just dexec "flutter run"

dshell:
    just dexec "bash"
