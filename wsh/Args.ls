
  do ->

    { enumerate } = dependency wsh.Enumeration
    { Str, Num } = dependency primitive.Type

    WScript.Arguments

      named = ..Named
      unnamed = ..Unnamed

    named

      paramc = ..Count
      param-by-name = -> ..Item Str it
      has-param = -> ..Exits Str it

    unnamed

      argc = ..Count
      arg-by-index = -> ..Item Num it

    params = { [ name, param-by-name name ] for name in enumerate named }

    args = [ (arg-by-index index) for index til argc ]

    {
      paramc, has-param, param-by-name, params,
      argc, arg-by-index, args
    }
