Npm2Arch
========

Convert npm packages into a PKGBUILD for Archlinux integration.

NPM package.json --> PKGBUILD for pacman


Install
-------
### From AUR : 
yaourt -S nodejs-npm2arch
<https://aur.archlinux.org/packages.php?ID=53502>


### From sources

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


### npm2archinstall

Install a npm package with pacman

    npm2archinstall `npm-name`


License
-------

The MIT License (MIT)
Copyright (c) 2011 Filirom1

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
