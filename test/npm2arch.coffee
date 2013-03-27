{npm2PKGBUILD, createPkg} = require '../index'
mocha  = require 'mocha' 
vows   = require 'vows'
assert = require 'assert'
path   = require 'path'
fs     = require 'fs'
rimraf = require 'rimraf'

cwd = process.cwd()

describe 'Test npm2arch', ->

  it 'should create a PKGBUILD when calling npm2PKGBUILD with an existing package in npm', (done) ->
      npm2PKGBUILD 'npm2arch', depends: ['curl', 'git'], optdepends: [ phantomjs: 'browser-run test suite'], (err, pkgbuild) ->
        assert.isNull err
        assert.isNotNull pkgbuild
        assert.include pkgbuild, "# Author: Filirom1 <filirom1@gmail.com>"
        assert.include pkgbuild, "# Maintainer: filirom1 <filirom1@gmail.com>"
        assert.include pkgbuild, "license=(MIT)"
        assert.include pkgbuild, 'url="https://github.com/Filirom1/npm2arch"'
        assert.include pkgbuild, 'pkgdesc="Convert NPM package to a PKGBUILD for ArchLinux"'
        assert.include pkgbuild, "depends=('nodejs' 'curl' 'git' )"
        assert.include pkgbuild, "optdepends=('phantomjs: browser-run test suite' )"
        done()

  it 'should put in lower case package name in UPPER CASE', (done)->
      npm2PKGBUILD 'CM1', (err, pkgbuild) ->
        assert.isNull err
        assert.isNotNull pkgbuild
        assert.include pkgbuild, "pkgname=nodejs-cm1"
        done()

  it 'should return an error when calling npm2PKGBUILD with a non existing package in npm', (done)->
      npm2PKGBUILD 'fqkjsdfkqjs',  (err, pkgbuild) ->
        assert.isNotNull err
        assert.equal '404 Not Found: fqkjsdfkqjs', err.message
        done()

  it 'should create a package when calling createPkg with a real package name', (done)->
      randomId =  (((1+Math.random())*0x10000)|0).toString(16).substring(1)
      dir = "/tmp/test-npm2arch-#{randomId}-dir/"
      fs.mkdirSync dir
      process.chdir dir
      createPkg 'npm2arch', ['--source'], verbose: false, (err, file) ->
        assert.isNull err
        assert.include file, '/tmp/'
        assert.include file, '-dir/'
        assert.include file, 'nodejs-npm2arch-'
        assert.include file, '.src.tar.gz'
        assert.isTrue path.existsSync file
        rimraf.sync path.dirname file
        done()

  it 'should return an error when calling createPkg with a bad package name', (done)->
      createPkg 'qsdfqsdfqsd', ['--source'], verbose: false, (err, file) ->
        assert.isNotNull err
        assert.equal '404 Not Found: qsdfqsdfqsd', err.message
        done()
