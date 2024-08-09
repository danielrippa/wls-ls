
  do ->

    { split-array-at, reject-items, map-items } = dependency native.Array
    { trimmed-is-empty, entity-encode } = dependency native.String
    { text-as-lines } = dependency primitive.Text
    { MaybeStr } = dependency primitive.Type
    { object-from-arrays } = dependency native.Object

    string-as-columns = (/ '|')

    output-as-header-and-lines = (output) ->

      [ header, lines ] = output |> text-as-lines |> split-array-at _ , 1

      lines = reject-items lines, trimmed-is-empty

      [ header, lines ]

    output-as-obj-list = (output) ->

      if output isnt void

        [ header, lines ] = output |> output-as-header-and-lines

        map-items lines, (line) -> object-from-arrays (header |> string-as-columns), string-as-columns line

      else

        []

    #

    output-as-obj = (output) ->

      if (MaybeStr output) is void

        return {}

      else

        [ header, [ line ] ] = output |> output-as-header-and-lines

        object-from-arrays (header |> string-as-columns), string-as-columns line

    {
      output-as-obj, output-as-obj-list
    }