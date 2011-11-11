fs       = require 'fs.extra'
path     = require 'path'
util     = require 'util'
rimraf   = require 'rimraf'
{spawn}  = require 'child_process'
npm2arch = require './npm2PKGBUILD'


module.exports = (npmName, makePkgArgv, cb, verbose) ->
  if typeof makePkgArgv is 'function'
    cb = makePkgArgv
    makePkgArgv = null
  makePkgArgv or= []
  verbose = true if verbose is undefined or verbose is null

  randomId =  (((1+Math.random())*0x10000)|0).toString(16).substring(1)
  tmpDir = '/tmp/npm2archinstall-' + randomId

  # Create a package for archlinux with makepkg cmd
  npm2arch npmName, (err, pkgbuild)->
    return cb err if err
    # Create a tmp directory to work on
    fs.mkdir tmpDir, '0755', (err)->
      cwd = process.cwd()
      process.chdir tmpDir
      # Write the PKGBUILD file on the cwd
      fs.writeFile 'PKGBUILD', pkgbuild, (err)->
        return cb err if err
        # Spawn makepkg
        child = spawn 'makepkg', makePkgArgv
        child.stdout.pipe(process.stdout, end: false) if verbose
        child.stderr.pipe(process.stderr, end: false) if verbose
        child.on 'exit', (code) ->
          cb err "Bad status code returned from `makepkg`: #{code}" if code is not 0
          # Get the package file name
          fs.readdir tmpDir, (err, files)->
            return cb err if err
            pkgFile = (files.filter (file)-> file.indexOf('nodejs-') is 0)[0]
            newPkgFile = path.join(cwd, path.basename pkgFile)
            fs.unlinkSync newPkgFile if path.existsSync newPkgFile
            fs.move path.join(tmpDir, pkgFile), newPkgFile, (err)->
              cb err if err
              # Delete the tmp directory
              rimraf tmpDir, (err) ->
                return cb err if err
                process.chdir cwd
                cb null, newPkgFile
