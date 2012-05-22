{run} = require './helpers'

module.exports = class Git
  constructor: (path, options = {}) ->
    @path

  cmd: (cmd, done) ->
    run cmd, {cwd: @path}, done

  head: (done) ->
    @cmd 'cat .git/HEAD', (output) ->
      done output
