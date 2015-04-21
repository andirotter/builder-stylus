stylus = require 'stylus'
crc32 = require('crc32')
cache = Object.create(null)

exports = module.exports = (options) ->
  options = options or {}
  (file, done) ->

    if ! ~exports.extensions.indexOf(file.extension)
      return done()

    file.read (err, string) ->
      if err
        return done(err)
      hash = file.filename + '#' + crc32(string)
      res = undefined
      try
        res = cache[hash] = cache[hash] or stylus.render(string, options)
      catch err
        done err
        return
      file.extension = 'css'

      file.string = res
      done()
      return
    return

# extensions to support
module.exports.extensions = [
  'styl'
  'stylus'
]
