
  do ->

    { control-chars: { lf } } = dependency native.String
    { new-shell } = dependency wsh.Shell

    stdin = -> WScript.StdIn.ReadAll!

    #

    [ stdout, stderr ] = do ->

      writer = (suffix) ->

        -> WScript["Std#suffix"].Write [ (arg) for arg in arguments ] * ' '

      [ (writer suffix) for suffix in <[ Out Err ]> ]

    #

    writers = (write) ->

      * -> write lf ; write ...
        -> write ... ; write lf

    [ lnout, outln ] = writers stdout
    [ lnerr, errln ] = writers stderr

    #

    debug = -> new-shell!Run "%tools-path%\\ods\\ods.exe #{ [ (arg) for arg in arguments ] * ' ' }", 0, no

    {
      stdin,
      stdout, stderr,
      lnout, outln,
      lnerr, errln,
      debug
    }