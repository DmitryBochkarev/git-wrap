{Runner, parseCommitDump, parseTreeDump, parseHistoryDump} = require './helpers'
fs = require 'fs'
path = require 'path'
async = require 'async'

module.exports = class Git
  constructor: (path, options = {}) ->
    return new Git(arguments...) unless this instanceof Git
    @path = path
    @run = Runner @path

  head: (done) ->
    fs.readFile path.resolve(@path, '.git/HEAD'), 'utf8', (err, head) =>
      throw err if err
      head = (head or '').trim().slice(16)
      fs.readFile path.resolve(@path, ".git/refs/heads/#{head}"), 'utf8', (err, sha) ->
        done(undefined, {
          name: head,
          sha: "#{sha}".trim()
        })

  heads: (done) ->
    dir = path.resolve(@path, '.git/refs/heads')
    fs.readdir dir, (err, files) ->
      throw err if err
      heads = []
      iterator = (file, done) ->
        fs.readFile path.resolve(dir, file), 'utf8', (err, content) ->
          throw err if err
          heads.push sha: "#{content}".trim(), name: file
          done undefined
      async.forEachSeries files, iterator, (err) ->
        throw err if err
        done undefined, heads

  history: (done) ->
    cmd = "git log --pretty=format:'%H;%ai;%an;%ae;%s'"
    @run cmd, (err, dump) ->
      done undefined, parseHistoryDump(dump)

  objectType: (sha, done) ->
    cmd = "git cat-file -t #{sha}"
    @run cmd, (err, type) ->
      done undefined, "#{type}".trim()

  objectDump: (sha, done) ->
    cmd = "git cat-file -p #{sha}"
    @run cmd, (err, dump) ->
      done undefined, dump

  object: (sha, done) ->
    async.series
      type: (done) => @objectType sha, done
      dump: (done) => @objectDump sha, done
    , (err, {type, dump}) ->
      switch type
        when 'commit' then done undefined, {sha, type, data: parseCommitDump(dump)}
        when 'tree' then done undefined, {sha, type, objects: parseTreeDump(dump)}
        else
          done undefined, {sha, type, dump}

  lsTree: (name, done) ->
    cmd = "git ls-tree #{name}"
    @run cmd, (err, dump) ->
      done undefined, {objects: parseTreeDump(dump)}

  sha: (rev, done) ->
    cmd = "git rev-parse #{rev}"
    @run cmd, (err, sha) ->
      done undefined, sha

  objectByPath: (rev, path, done) ->
    @sha "#{rev}:#{path}", (err, sha) =>
      @object "#{sha}".trim(), done


