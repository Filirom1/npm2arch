#!/usr/bin/env node
require('coffee-script');
var npm2arch = require('../lib/npm2arch.coffee');

if(process.argv.length != 3){
  console.error("Usage: npm2PKGBUILD `npm-name` > PKGBUILD");
  process.exit(-1);
}

var npmName = process.argv[2];

// Show on the console the PKGBUILD
npm2arch(npmName, function(err, pkgbuild){
  if(err) {
    console.error(err);
    process.exit(-1);
  }
  console.log(pkgbuild);
});
