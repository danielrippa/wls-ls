
  do ->

    { Str } = dependency primitive.Type
    { StrList } = dependency primitive.List
    { run } = dependency wsh.Process
    { double-quotes } = dependency native.String
    { map } = dependency native.Array
    { read-object } = dependency wsh.ObjectFile
    { build-path } = dependency wsh.FileSystem
    { script-folder, fail-lines } = dependency wsh.Script
    { expand-vars } = dependency wsh.EnvVar

    #

    quoted = -> [ (double-quotes value) for value in it ] * ' '

    dashed = -> [ "-#value" for value in it ] * ' '

    #

    config-file = 'sqlite.conf'

    process-error = (error-type, message) -> fail-lines [ "sqlite.Process #error-type error: ", message ]

    config-file-error = (message) -> process-error "configuration file '#config-file'", message

    get-config = ->

      config-filepath = build-path script-folder, config-file

      try config = read-object config-filepath
      catch => config-file-error e.message

      config

    #

    sqlite-exec = (db-filepath, commands = [], options = []) ->

      Str db-filepath ; StrList commands ; StrList options

      { exe-filepath } = get-config!

      config-file-error "Configuration file must contain a 'exe-filepath' entry with a resolvable path to the sqlite3 exe file." \
        if exe-filepath is void

      sqlite-exe = expand-vars exe-filepath

      try { output, error, errorlevel, actual-command } = run "#sqlite-exe #{ double-quotes db-filepath } #{ dashed options } #{ quoted commands }"
      catch => process-error "execution (run)", e.message

      if error isnt void
        process-error "execution (error isnt void)", error

      if errorlevel isnt 0
        process-error "execution (errorlevel isnt 0)", "Failed to execute #actual-command"

      output

    {
      sqlite-exec
    }
