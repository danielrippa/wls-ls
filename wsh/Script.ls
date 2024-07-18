
  do ->

    { Num } = dependency primitive.Type
    { parent-folder } = dependency wsh.FileSystem

    WScript

      script-name = ..ScriptName
      script-full-name = ..ScriptFullName

      script-folder = parent-folder script-full-name

      exit = (errorlevel = 0) !-> ..Quit Num errorlevel

      sleep = (seconds = 1) !-> ..Sleep (Num seconds) * 1000

    {
      script-name, script-full-name, script-folder,
      exit, sleep
    }