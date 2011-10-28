Npm2Arch
========

Convert npm packages into a PKGBUILD for Archlinux integration.

NPM package.json --> PKGBUILD for pacman


Install
-------

    git clone https://github.com/Filirom1/npm2arch
    cd npm2arch
    [sudo] npm install -g


Usage
-----

### npm2PKGBUILD

Transform a npm package into an ArchLinux PKGBUILD

    npm2PKGBUILD `npm-name` > PKGBUILD
    makepkg
    pacman -U nodejs-`name`-`version`-any.pkg.tar.xz

### npm2archpkg

Transform a npm package into an ArchLinux package archive

    npm2archpkg `npm-name`
    pacman -U nodejs-`name`-`version`-any.pkg.tar.xz
