FROM archlinux:base-devel

WORKDIR /usr/files

ENV REPO="git@github.com:torvalds/linux.git"
ENV CRON="0 * * * *"

RUN pacman -Sy --noconfirm openssh git jq cronie doas && \
  groupadd user && \
  useradd -m -g user user && \
  ln -sf /usr/files/.cron /etc/cron.d/.cron && \
  ln -sf /usr/volume/common/gitconfig /home/user/.gitconfig && \
  rm -rf /home/user/.ssh && \
  ln -sf /usr/volume/common/ssh /home/user/.ssh && \
  ssh-keyscan -t rsa aur.archlinux.org >> ./known_hosts && \
  ssh-keyscan -t rsa github.com >> ./known_hosts && \
  ssh-keyscan -t rsa gitlab.com >> ./known_hosts && \
  chown user:user . && \
  echo "permit nopass :user as root cmd $(which crond)" > /etc/doas.conf && \
  chmod 0400 /etc/doas.conf

COPY . .

USER user

CMD ./startup.sh
