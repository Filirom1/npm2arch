#!/usr/bin/env coffee
npm      = require 'npm'
mustache = require 'mustache'
fs       = require 'fs'

# transform pkg.json of `npmName` into a PKGBUILD
# `cb` is called like this: `cb(err, pkgbuild)`
module.exports = (npmName, options, cb) ->

  if typeof options is 'function'
    cb = options
    options = null

  options or= {}

  # Execute npm info `argv[0]`
  npm.load loglevel:'silent', (er)->
    return cb(er) if er
    npm.commands.view [npmName], true, (er, json) ->
      return cb(er) if er
      parseNPM json

  # Parse the info json
  parseNPM = (data) ->
    version = Object.keys(data)[0]
    pkg = data[version]
    pkg = cleanup pkg
    pkg.nameLowerCase = pkg.name.toLowerCase()
    pkg.contributors = [pkg.contributors] if typeof pkg.contributors is 'string'
    pkg.maintainers = [pkg.maintainers] if typeof pkg.maintainers is 'string'
    pkg.homepage or= pkg.url
    pkg.homepage or= pkg.repository.url.replace(/^git(@|:\/\/)/, 'http://').replace(/\.git$/, '').replace(/(\.\w*)\:/g, '$1\/') if pkg.repository?.url
    pkg.depends = options.depends
    populateTemplate pkg

  # Populate the template
  populateTemplate = (pkg) ->
    cb null, mustache.to_html(template, pkg)


template = '''{{#author}}
# Author: {{{author}}}
{{/author}}
{{#contributors}}
# Contributor: {{{.}}}
{{/contributors}}
{{#maintainers}}
# Maintainer: {{{.}}}
{{/maintainers}}
_npmname={{{name}}}
pkgname=nodejs-{{{nameLowerCase}}} # All lowercase
pkgver={{{version}}}
pkgrel=1
pkgdesc=\"{{{description}}}\"
arch=(any)
url=\"{{{homepage}}}\"
license=({{#licenses}}{{{type}}}{{/licenses}})
depends=('nodejs' {{#depends}}'{{{.}}}' {{/depends}})
source=(http://registry.npmjs.org/$_npmname/-/$_npmname-$pkgver.tgz)
noextract=($_npmname-$pkgver.tgz)
sha1sums=({{#dist}}{{{shasum}}}{{/dist}})

build() {
  cd $srcdir
  local _npmdir="$pkgdir/usr/lib/node_modules/"
  mkdir -p $_npmdir
  cd $_npmdir
  npm install -g --prefix "$pkgdir/usr" $_npmname@$pkgver
}

# vim:set ts=2 sw=2 et:'''

# From NPM sources
`function cleanup (data) {
  if (Array.isArray(data)) {
    if (data.length === 1) {
      data = data[0]
    } else {
      return data.map(cleanup)
    }
  }
  if (!data || typeof data !== "object") return data

  if (typeof data.versions === "object"
      && data.versions
      && !Array.isArray(data.versions)) {
    data.versions = Object.keys(data.versions || {})
  }

  var keys = Object.keys(data)
  keys.forEach(function (d) {
    if (d.charAt(0) === "_") delete data[d]
    else if (typeof data[d] === "object") data[d] = cleanup(data[d])
  })
  keys = Object.keys(data)
  if (keys.length <= 3
      && data.name
      && (keys.length === 1
          || keys.length === 3 && data.email && data.url
          || keys.length === 2 && (data.email || data.url))) {
    data = unparsePerson(data)
  }
  return data
}
function unparsePerson (d) {
  if (typeof d === "string") return d
  return d.name
       + (d.email ? " <"+d.email+">" : "")
       + (d.url ? " ("+d.url+")" : "")
}`
