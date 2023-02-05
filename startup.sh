#!/bin/bash
cd /usr/files
mkdir -p /usr/volume/common/ssh && chown user:user /usr/volume/common/ssh && chmod 700 /usr/volume/common/ssh
touch /usr/volume/common/gitconfig
if [ -z "$(ls -A ~/.ssh/)" ]; then
    echo "==> SSH folder empty. Generating key..."
    ssh-keygen -t ed25519 -C "aur-deploy" -f "/usr/volume/common/ssh/id_ed25519" -N ""
    echo "==> Public key:"
    cat ~/.ssh/id_ed25519.pub
fi
$(which cp) -u /usr/files/known_hosts /usr/volume/common/ssh/known_hosts && chmod 600 /usr/volume/common/ssh/known_hosts
if [ ! -d "repo" ]; then
    echo "==> Cloning repo..."
    git clone "$REPO" repo || exit 500
else
    echo "==> Repo found. Pulling from origin..."
    cd repo
    git reset --hard HEAD
    git pull || exit 1
    cd ..
fi
rm -f /usr/volume/common/ssh/known_hosts.old
echo "==> Ready. Cron job is scheduled."
R=$(echo "$CRON")
sed "s|%CRON%|$R|" /usr/files/cron > /usr/files/.cron
crontab /etc/cron.d/.cron
doas `which crond` -n
