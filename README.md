# aur-deploy
Docker image that automates the updating of AUR packages or other git repositories

## CI

Thanks to GitHub automatically disabling rehydration of my images, I've moved this project to [my personal Gitea instance](https://git.sanin.dev/corysanin/aur-deploy). Builds now run within Gitea.

## Configuration

Use the provided [docker-compose file](docker-compose.yml) as a guide. 

aur-deploy takes environment variables:

| Environment Variable | Description                                                                                    |
|----------------------|------------------------------------------------------------------------------------------------|
| CRON                 | Cron expression for how often aur-deploy should run the update routine. Default is `0 * * * *` |
| REPO                 | The address of the git repository to be modified                                               |

There are also some configuration files that are provided in `/usr/volume/`:

```bash
/usr/volume/
├── common
│   ├── gitconfig           # .gitconfig file
│   └── ssh                 # .ssh directory
│       ├── id_ed25519
│       └── id_ed25519.pub
└── script
    └── script.sh           # script that updates your PKGBUILD
```

Note that if the ssh directory is empty, a key will be automatically generated. Just add the public key to your AUR account.

## script.sh

This script runs within the repository directory. It should check for an update and make the appropriate changes to the PKGBUILD file. No need to update the .SRCINFO and no need to stage PKGBUILD or .SRCINFO. All other files that aren't staged will be removed, so don't worry about cleaning up.

The script is also responsible for updating checksums. Consider using `git diff --exit-code PKGBUILD || updpkgsums` at the end of the script. This will only update checksums if a change is detected.