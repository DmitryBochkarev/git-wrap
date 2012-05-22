{exec} = require 'child_process'

module.exports.run = (cmd, options, done) ->
  [done, options] = [options, {}] if typeof options is 'function'
  output = ''
  child = exec cmd, options
  child.stdout.on 'data', (data) ->
    output += data
  child.stderr.on 'data', (data) ->
    output += data
  child.on 'exit', ->
    done output
