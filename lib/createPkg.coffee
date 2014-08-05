fs       = require 'fs.extra'
path     = require 'path'
util     = require 'util'
rimraf   = require 'rimraf'
{spawn}  = require 'child_process'
npm2arch = require './npm2PKGBUILD'
UUID     = require 'uuid-js'


module.exports = (npmName, makePkgArgv, options, cb) ->
  if typeof makePkgArgv is 'function'
    cb = makePkgArgv
    makePkgArgv = null
    options = null
  if typeof options is 'function'
    cb = options
    options = null
  aurball = makePkgArgv == 'aurball'
  makePkgArgv = [] if aurball
  makePkgArgv or= []
  options or= verbose: true
  verbose = options.verbose
  randomId = UUID.create()
  tmpDir = '/tmp/npm2archinstall-' + randomId

  # Create a package for archlinux with makepkg cmd
  npm2arch npmName, options, (err, pkgbuild)->
    return cb err if err
    # Create a tmp directory to work on
    fs.mkdir tmpDir, '0755', (err)->
      return cb err if err
      cb2 = ->
        arg = arguments
        # Delete the tmp directory
        rimraf tmpDir, (err) ->
          return cb err if err
          cb.apply(this, arg)

      # Write the PKGBUILD file in the tmpDir
      fs.writeFile path.join(tmpDir, "PKGBUILD"), pkgbuild, (err)->
        return cb2 err if err
        # Spawn makepkg/mkaurball
        stdio = if verbose then 'inherit' else 'ignore'
        opts = cwd: tmpDir, env: process.env, setsid: false, stdio: stdio
        child = if aurball
          spawn 'mkaurball', [], opts
        else
          spawn 'makepkg', makePkgArgv, opts
        child.on 'exit', (code) ->
          makepkg = if aurball then 'mkaurball' else 'makepkg'
          cb2 err "Bad status code returned from `#{makepkg}`: #{code}" if code is not 0
          # Get the package file name
          fs.readdir tmpDir, (err, files)->
            return cb2 err if err
            pkgFile = (files.filter (file)-> file.indexOf('nodejs-') is 0)[0]
            newPkgFile = path.join(process.cwd(), path.basename pkgFile)
            fs.unlinkSync newPkgFile if fs.existsSync newPkgFile
            fs.move path.join(tmpDir, pkgFile), newPkgFile, (err)->
              cb2 err if err
              cb2 null, newPkgFile
