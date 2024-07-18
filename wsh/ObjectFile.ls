
  do ->

    { read-lines } = dependency wsh.TextFile
    { string-as-words, trim, first, camel-case } = dependency native.String
    { first, drop } = dependency native.Array
    { Str } = dependency primitive.Type

    read-object = (filepath) ->

      object = {}

      for line in read-lines filepath

        line = trim line

        line-chars = line / ''

        continue if (first line-chars) is '#'

        words = line |> string-as-words

        key = words.0

        value-chars = line-chars `drop` key.length

        value = value-chars * ''

        object[ camel-case key ] = trim value

      object

    {
      read-object
    }

