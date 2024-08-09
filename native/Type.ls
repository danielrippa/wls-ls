
  do ->

    { trim, lower-case, double-quotes, square-brackets, braces } = dependency native.String
    { array-as-object } = dependency native.Array
    { function-as-string } = dependency native.Function

    type-name = (value) -> {} |> (.to-string) |> (.call value) |> (.slice 8, -1)

    sanitize = -> it |> trim |> lower-case

    is-a = (value, type) ->

      value-type = value |> type-name |> sanitize
      type = type |> sanitize

      value-type is type

    isnt-a = (value, type) -> not (value `is-a` type)

    #

    n = native-type = array-as-object <[ String Object Number Array Arguments Boolean Function Undefined Error Null NaN ]>

    #

    value-as-string = (value) ->

      switch type-name value

        | p.String => double-quotes value
        | p.Function => function-as-string value
        | p.Array, p.Arguments, p.Error => square-brackets ( [ (value-as-string item) for item in value ] * ', ' )
        | p.Object => braces ( [ [ (property-as-string property-name), (value-as-string property-value) ] for property-name, property-value of value ] * ', ' )
        | p.Undefined => 'void'
        | p.Null => 'null'
        | p.NaN => 'NaN'

        else String value

    {
      type-name, native-type,
      is-a, isnt-a,
      value-as-string
    }
