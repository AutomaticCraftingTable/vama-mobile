FROM instrumentisto/flutter:3.29

ENV PROMPT_FORMAT="\[\e[34m\][\u@docker:\[\e[35m\]\w\[\e[34m\]]$\[\e[0m\] "

RUN { echo "umask 0000"; echo 'export PS1=$PROMPT_FORMAT'; } \
  | tee -a /etc/bash.bashrc /root/.bashrc

ENTRYPOINT ["./environment/app/entrypoint.sh"]
