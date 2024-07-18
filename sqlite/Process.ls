
  do ->

    { Str } = dependency primitive.Type
    { StrList } = dependency primitive.List
    { run } = dependency wsh.Process
    { double-quotes } = dependency native.String
    { map } = dependency native.Array
    { read-object } = dependency wsh.ObjectFile
    { build-path } = dependency wsh.FileSystem
    { script-folder } = dependency wsh.Script
    { expand-vars } = dependency wsh.EnvVar
    { debug } = dependency wsh.IO

    #

    quoted = -> [ (double-quotes value) for value in it ] * ' '

    dashed = -> [ "-#value" for value in it ] * ' '

    #

    get-config = -> read-object build-path script-folder, 'sqlite.conf'

    #

    sqlite-exec = (db-filepath, commands = [], options = []) ->

      Str db-filepath ; StrList commands ; StrList options

      { exe-filepath } = get-config!

      sqlite-exe = expand-vars exe-filepath

      { output, error, errorlevel, actual-command } = run "#sqlite-exe #{ double-quotes db-filepath } #{ dashed options } #{ quoted commands }"

      debug actual-command, errorlevel

      if error isnt void
        throw new Error error

      if errorlevel isnt 0
        throw new Error "Failed to execute #actual-command"

      output

    {
      sqlite-exec
    }
