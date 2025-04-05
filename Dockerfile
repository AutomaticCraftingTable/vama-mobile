FROM instrumentisto/flutter:3.29

RUN apt-get update \
 && apt-get install -y --no-install-recommends curl ca-certificates \
 && curl --proto '=https' --tlsv1.2 -sSf https://just.systems/install.sh | bash -s -- --to /usr/local/bin \
 && apt-get remove -y curl \
 && apt-get autoremove -y \
 && rm -rf /var/lib/apt/lists/*

ENV PROMPT_FORMAT="\[\e[34m\][\u@docker:\[\e[35m\]\w\[\e[34m\]]$\[\e[0m\] "

RUN { echo "umask 0000"; echo 'export PS1=$PROMPT_FORMAT'; } \
  | tee -a /etc/bash.bashrc /root/.bashrc
