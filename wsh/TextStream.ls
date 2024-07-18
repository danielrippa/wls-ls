
  do ->

    { new-filesystem } = dependency wsh.FileSystem
    { Str, Num, Bool } = dependency primitive.Type

    fs = new-filesystem!

    io-mode = reading: 1, writing: 2, appending: 8

    new-textstream = (filepath, mode) -> new-filesystem!OpenTextFile (Str filepath), (Num mode)

    readable = -> new-textstream it, io-mode.reading

    writeable = (filepath, appending = no) -> new-textstream filepath, (if (Bool appending) then io-mode.appending else io-mode.writing)

    {
      readable, writeable
    }