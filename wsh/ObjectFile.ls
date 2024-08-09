
  do ->

    { read-lines } = dependency wsh.TextFile
    { string-as-words, trim, take-first-chars, camel-case, drop-first-chars } = dependency native.String

    read-object = (filepath) ->

      object = {}

      try lines = read-lines filepath
      catch => throw new Error "ObjectFile '#filepath' unable to read-lines. Error: #{ e.message }"

      for line in lines

        line = trim line

        if line.length is 0
          continue

        if (take-first-chars line) is '#'
          continue

        words = line |> string-as-words

        key = words.0

        value = line `drop-first-chars` key.length

        object[ camel-case key ] = trim value

      object

    {
      read-object
    }

