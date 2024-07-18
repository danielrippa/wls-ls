
  do ->

    { new-shell } = dependency wsh.Shell
    { new-tempfile } = dependency wsh.TempFile
    { Str, Num, Bool, MaybeStr } = dependency primitive.Type
    { text-as-string } = dependency primitive.Text
    { double-quotes } = dependency native.String
    { debug } = dependency wsh.IO
    { read } = dependency wsh.TextFile
    { file-exists } = dependency wsh.FileSystem

    window-behaviors =

      hide-and-activate-another: 0

    run = (command, working-folder, window-behavior = window-behaviors.hide-and-activate-another, synchronous = yes) ->

      Str command ; MaybeStr working-folder ; Num window-behavior ; Bool synchronous

      files = [ (new-tempfile!) for index to 1 ]

      [ out, err ] = files

      actual-command = "%comspec% /c #command > #{ double-quotes out.filename } 2> #{ double-quotes err.filename }"

      shell = new-shell!

      try

        shell.CurrentDirectory = working-folder \
          if working-folder isnt void

        errorlevel = shell.Run actual-command, window-behavior, synchronous

      catch

        message =

          * "wsh.Process.Run #actual-command"
            e.message
          |> text-as-string

        throw new Error message

      if errorlevel isnt 0

        debug "wsh.Process.run with errorlevel #errorlevel"
        debug "wsh.Process.run #actual-command"

      [ output, error ] = [ (file.consume!) for file in files ]

      { command, actual-command, working-folder, output, error, errorlevel }

    {
      run
    }