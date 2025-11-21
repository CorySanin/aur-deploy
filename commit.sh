#!/bin/bash
cd /usr/files/repo
echo "==> Checking for updates..."
git pull || exit 1
/usr/volume/script/script.sh
git clean -fdx
if [[ `git status --porcelain` ]]; then
    echo "==> Update detected"
    sed -i -e 's|^pkgrel=.*|pkgrel=1|g' ./PKGBUILD
    makepkg --printsrcinfo > .SRCINFO
    git diff ./PKGBUILD
    git add PKGBUILD .SRCINFO
    pkgname="$(grep -oP '(?<=pkgname = ).*' .SRCINFO)"
    pkgver="$(grep -oP '(?<=pkgver = ).*' .SRCINFO)"
    commit="$pkgname $pkgver-1"
    echo "==> pushing $commit"
    git commit -m "upgpkg: $commit" -m "pushed by aur-deploy"
    git push origin HEAD
else
    echo "==> No update detected"
fi
