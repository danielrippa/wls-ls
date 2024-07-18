
  do ->

    { readable, writeable } = dependency wsh.TextStream
    { text-as-lines, lines-as-text } = dependency primitive.Text

    use-stream = (stream, fn) ->

      try result = fn stream
      catch => debug "wsh.TextFile.use-stream" ; debug e.message

      stream.Close!
      result

    read = -> use-stream (readable it), (.ReadAll!)

    write = -> (filepath, content, appending = no) -> use-stream (writeable filepath, appending), (.Write content)

    append = (filepath, content) -> write filepath, content, yes

    read-lines = (filepath) -> read filepath |> text-as-lines

    write-lines = (filepath, lines) -> write filepath, (lines |> lines-as-text)

    append-lines = (filepath, lines) -> append filepath, (lines |> lines-as-text)

    {
      read, write, append,
      read-lines, write-lines, append-lines
    }

