
  do ->

    { Num } = dependency primitive.Type
    { parent-folder } = dependency wsh.FileSystem
    { errln } = dependency wsh.IO

    WScript

      script-name = ..ScriptName
      script-full-name = ..ScriptFullName

      script-folder = parent-folder script-full-name

      exit = (errorlevel = 0) !-> ..Quit Num errorlevel

      sleep = (seconds = 1) !-> ..Sleep (Num seconds) * 1000

      usage-lines = (args, lines = []) ->

        * "Usage:"
          ""
          "#script-name #args"

        |> (++ lines)

      fail-lines = (message-lines, errorlevel = 1) ->

        for line in message-lines => errln line
        exit Num errorlevel

      fail = (message, errorlevel) -> fail-lines [ message ], errorlevel

    {
      script-name, script-full-name, script-folder,
      exit, sleep,
      usage-lines,
      fail, fail-lines
    }