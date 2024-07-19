
  do ->

    { split-at } = dependency native.Array
    { text-as-lines } = dependency primitive.Text
    { trim } = dependency native.String
    { MaybeStr } = dependency primitive.Type

    #
    string-as-columns = (/ '|')

    #

    columns-as-object = (column-names, column-values) ->

      { [ (column-name), (column-values[index]) ] for column-name, index in column-names }

    #

    output-as-objects = (output) ->

      MaybeStr output

      objects = []

      if output is void
        return objects

      if (trim output) is ''
        return objects

      [ header, lines ] = output |> text-as-lines |> split-at _ , 1

      column-names = header |> string-as-columns

      for line in lines

        continue if (trim line) is ''

        column-values = line |> string-as-columns

        objects.push columns-as-object column-names, column-values

      objects

    {
      output-as-objects
    }