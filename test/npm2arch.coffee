{npm2PKGBUILD, createPkg} = require '../index'
vows   = require 'vows'
assert = require 'assert'
path   = require 'path'
fs     = require 'fs'
rimraf = require 'rimraf'

cwd = process.cwd()

vows.describe('Test npm2arch')
.addBatch
  'When calling npm2PKGBUILD with an existing package in npm':
    topic: ->
      npm2PKGBUILD 'npm2arch', depends: ['curl', 'git'], @callback
      return
    'Then a PKGBUILD is created': (err, pkgbuild) ->
      assert.isNull err
      assert.isNotNull pkgbuild
      assert.include pkgbuild, "# Author: Filirom1 <filirom1@gmail.com>"
      assert.include pkgbuild, "# Maintainer: filirom1 <filirom1@gmail.com>"
      assert.include pkgbuild, "license=(MIT)"
      assert.include pkgbuild, 'url="https://github.com/Filirom1/npm2arch"'
      assert.include pkgbuild, 'pkgdesc="Convert NPM package to a PKGBUILD for ArchLinux"'
      assert.include pkgbuild, "depends=('nodejs' 'curl' 'git' )"

  'When calling npm2PKGBUILD with a packge in UPPER CASE':
    topic: ->
      npm2PKGBUILD 'CM1', @callback
      return
    'Then the AUR pkgname is in lowercase': (err, pkgbuild) ->
      assert.isNull err
      assert.isNotNull pkgbuild
      assert.include pkgbuild, "pkgname=nodejs-cm1"

  'When calling npm2PKGBUILD with a non existing package in npm':
    topic: ->
      npm2PKGBUILD 'fqkjsdfkqjs', @callback
      return
    'Then an error happen': (err, pkgbuild) ->
      assert.isNotNull err
      assert.equal '404 Not Found: fqkjsdfkqjs', err.message

  'When calling createPkg with a real package name':
    topic: ->
      randomId =  (((1+Math.random())*0x10000)|0).toString(16).substring(1)
      dir = "/tmp/test-npm2arch-#{randomId}-dir/"
      fs.mkdirSync dir
      process.chdir dir
      createPkg 'npm2arch', ['--source'], verbose: false, @callback
      return
    'Then a package is created': (err, file) ->
      assert.isNull err
      assert.include file, '/tmp/'
      assert.include file, '-dir/'
      assert.include file, 'nodejs-npm2arch-'
      assert.include file, '.src.tar.gz'
      assert.isTrue path.existsSync file
      rimraf.sync path.dirname file

  'When calling createPkg with a bad package name':
    topic: ->
      createPkg 'qsdfqsdfqsd', ['--source'], verbose: false, @callback
      return
    'Then an error is returned': (err, file) ->
      assert.isNotNull err
      assert.equal '404 Not Found: qsdfqsdfqsd', err.message

.export module
