
  do ->

    { Either, type-name, primitive-type: p, Str, List } = dependency primitive.Type
    { control-chars: { us, cr, lf, ff, vt } } = dependency native.String

    Text = !-> Either <[ Str List ]> it
    MaybeText = !-> Either <[ Str List Void ]> it

    #

    crlf = "#cr#lf"

    #

    list-as-units = (list) -> List list ; list.join us

    units-as-list = (units) -> Str units ; units.split us

    #

    text-as-string = (text, separator = lf) ->

      Text text

      switch type-name text

        | p.List => text.join separator
        else String text

    #

    text-as-units = (text) ->

      for line-separator in [ crlf, lf, cr, ff, vt ]

        loop

          break if (text.index-of line-separator) is -1

          text = text.replace line-separator, us

      text

    units-as-text = (units, line-separator = crlf) -> units |> units-as-list |> (.join line-separator)

    #

    text-as-lines = (text) -> text |> text-as-string |> text-as-units |> units-as-list

    lines-as-text = (lines, line-separator = crlf) -> (List lines) |> (.join line-separator)

    {
      Text, MaybeText,
      text-as-string,
      text-as-lines, lines-as-text
    }