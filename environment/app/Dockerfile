FROM instrumentisto/flutter:3.29

RUN chmod -R a+rw /usr/local/flutter/packages/flutter_tools
RUN chmod -R a+rw /opt/android-sdk-linux

RUN apt-get update \
 && apt-get install -y --no-install-recommends curl ca-certificates \
 && curl --proto '=https' --tlsv1.2 -sSf https://just.systems/install.sh | bash -s -- --to /usr/local/bin \
 && apt-get remove -y curl \
 && apt-get autoremove -y \
 && rm -rf /var/lib/apt/lists/*

ARG USERNAME=user
ARG USER_ID=1000
ARG GROUP_ID=1000

RUN getent passwd ${USER_ID} \
 && sudo usermod -m -d /home/${USERNAME} -g ${GROUP_ID} -aG sudo -l ${USERNAME} $(id -nu ${USER_ID}) \
 && sudo passwd -d ${USERNAME} \
 || adduser --disabled-password --uid ${USER_ID} --gid ${GROUP_ID} ${USERNAME}

USER $USERNAME

ENV PROMPT_FORMAT="\[\e[34m\][\u@docker:\[\e[35m\]\w\[\e[34m\]]$\[\e[0m\] "

RUN echo 'export PS1=$PROMPT_FORMAT' \
 >> /home/${USERNAME}/.bashrc

