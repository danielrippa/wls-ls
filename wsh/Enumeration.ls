
  do ->

    { Fn } = dependency primitive.Type

    id = -> it

    enumerate = (enumeration, fn = id) ->

      Fn fn

      items = []

      new Enumerator enumeration

        ..move-first!

        loop

          break if ..at-end!

          items[*] = fn ..item!

          ..move-next!

      items

    {
      enumerate
    }