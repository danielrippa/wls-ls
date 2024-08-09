
  do ->

    { map-items } = dependency native.Array
    { trim, string-as-records, records-as-string } = dependency native.String

    decompose = (fn) ->

      string = fn.to-string!

        code-start = ..index-of \{
        code-end   = ..last-index-of \}

      original-code = string |> (.slice code-start + 1, code-end - 1)

      code =

        original-code

          |> string-as-records
          |> records-as-string
          |> map _ , trim
          |> (.join ' ')

      signature = string.slice 0, code-start

        parameters-start = ..index-of \(
        parameters-end   = ..last-index-of \)

      parameters-string = signature.slice parameters-start + 1, parameters-end

      parameters =

        if (trim parameters-string) is ''
          []
        else

          parameters-string
            |> (.split ',')
            |> map _ , trim

      { signature, parameters, original-code, code }

    parameters-of = (fn) -> decompose fn .parameters

    code-of = (fn) -> decompose fn .code |> trim

    parameters-as-string = (parameters) ->

      if parameters.length is 0
        ''
      else
        "( #{ parameters.join ', ' } ) "

    function-as-string = -> { parameters, code } = decompose it ; "#{ parameters-as-string parameters }-> {#code}"

    function-code-from-strings = ->

      if &1 is void
        parameters = ''
        statements = &0
      else
        parameters = &0 ; if parameters isnt '' then parameters = " #parameters "
        statements = &1

      "(#parameters) => { #{ statements * ' ; ' } ; } ;"

    {
      decompose,
      parameters-of, code-of,
      function-as-string,
      function-code-from-strings
    }