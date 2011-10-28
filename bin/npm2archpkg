#!/usr/bin/env node
require('coffee-script');
var npm2arch = require('../lib/npm2arch.coffee'),
          fs = require('fs'),
        util = require('util'),
        spawn = require('child_process').spawn;

if(process.argv.length < 3){
  console.error("Usage: npm2archpkg `npm-name` [-f or any makepkg arguments]");
  process.exit(-1);
}

var npmName = process.argv[2];
var otherArgv = process.argv.slice(3, process.argv.length);

function handleError(err){
  console.error(err);
  process.exit(-1);
}

// Create a package for archlinux with makepkg cmd
npm2arch(npmName, function(err, pkgbuild){
  if(err) handleError(err);
  // Write the PKGBUILD file on the cwd
  fs.writeFile('PKGBUILD', pkgbuild, function(err){
    if(err) handleError(err);
    // Pass to makepkg the remainings arguments of this call
    var child = spawn('makepkg', otherArgv);
    child.stdout.pipe(process.stdout, { end: false });
    child.stderr.pipe(process.stderr, { end: false });
    child.on('exit', function (code) {
      if (code !== 0) process.exit(code);
      fs.unlink('PKGBUILD', function(err){
        if(err) handleError(err);
      });
    });
  });
});
