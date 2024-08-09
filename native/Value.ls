
  do ->

    { type-name, native-type: n } = dependency native.Type
    { double-quotes, square-brackets, braces } = dependency native.String
    { function-as-string } = dependency native.Function

    value-as-string = (value) ->

      switch type-name value

        | n.String => double-quotes value
        | n.Function => function-as-string value
        | n.Array, n.Arguments, n.Error => square-brackets ( [ (value-as-string item) for item in value ] * ', ' )
        | n.Object =>

          switch value

            | undefined => 'void'

            else braces ( [ (property-as-string property-name, value-as-string property-value) for property-name, property-value of value ] * ', ' )

        | n.Undefined => 'void'
        | n.Null => 'null'
        | n.NaN => 'NaN'

        else String value

    {
      value-as-string
    }