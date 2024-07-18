
  do ->

    { trim, lower-case } = dependency native.String
    { array-as-object } = dependency native.Array

    type-name = (value) -> {} |> (.to-string) |> (.call value) |> (.slice 8, -1)

    sanitize = -> it |> trim |> lower-case

    is-a = (value, type) ->

      value-type = value |> type-name |> sanitize
      type = type |> sanitize

      value-type is type

    isnt-a = (value, type) -> not (value `is-a` type)

    #

    n = native-type = array-as-object <[ String Object Number Array Arguments Boolean Function Undefined Error ]>

    #

    {
      type-name, native-type,
      is-a, isnt-a
    }
