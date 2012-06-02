{exec} = require 'child_process'

module.exports.run = run = (cmd, cwd, done) ->
  [done, options] = [options, __dirname] if typeof options is 'function'
  output = ''
  error = ''
  child = exec cmd, {cwd}
  child.stdout.on 'data', (data) ->
    output += data
  child.stderr.on 'data', (data) ->
    error += data
  child.on 'exit', ->
    done error, output

module.exports.Runner = (path) ->
  (cmd, done) -> run cmd, path, done

module.exports.parseTreeDump = (dump) ->
  lines = "#{dump}".split '\n'
  objects = for line in lines[...-1]
    parts = "#{line}".split ' '
    [sha, name] = "#{parts[2]}".split '\t'
    object = {
      type: parts[1]
      sha: sha
      name: name
    }

module.exports.parseCommitDump = (dump) ->
  lines = "#{dump}".split '\n'
  result = {
    tree: "#{lines[0]}".slice(5)
    parent: "#{lines[1]}".slice(7)
  }

module.exports.parseHistoryDump = (dump) ->
  lines = "#{output}".split '\n'
  history = for line in lines
    parts = "#{line}".split ';'
    entry = {
      sha: parts[0]
      datetime: parts[1]
      author_name: parts[2]
      author_email: parts[3]
      subject: parts[4]
    }
