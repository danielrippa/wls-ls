
  do ->

    { read-lines } = dependency wsh.TextFile
    { string-as-words, trim, first-chars, camel-case, drop-chars } = dependency native.String

    read-object = (filepath) ->

      object = {}

      for line in read-lines filepath

        line = trim line

        if line.length is 0
          continue

        if (first-chars line) is '#'
          continue

        words = line |> string-as-words

        key = words.0

        value = line `drop-chars` key.length

        object[ camel-case key ] = trim value

      object

    {
      read-object
    }

