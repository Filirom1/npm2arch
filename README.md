Npm2Arch
========

Convert npm packages into a PKGBUILD for Archlinux integration.

NPM package.json --> PKGBUILD for pacman


Usage
-----

    npm2arch `npm-name` > PKGBUILD
    makepkg
    pacman -U nodejs-`name`-`version`-any.pkg.tar.xz
