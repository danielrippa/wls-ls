
  do ->

    { camel-case } = dependency native.String

    take = (array, n) ->

      if n <= 0
        array.slice 0, 0
      else
        array.slice 0, n

    drop = (array, n) ->

      if n <= 0
        array
      else
        array.slice n

    split-at = (array, n) -> [ (take array, n), (drop array, n) ]

    head-and-tail = -> it `split-at` 1

    first = (array) -> if array.length is 0 then void else array.0

    last = (array) -> if array.length is 0 then void else array[* - 1]

    array-as-object = (array) -> { [ (camel-case value), (value) ] for value in array }

    arrays-as-object = (names, values) -> { [ (name), (values[index]) ] for name, index in names }

    map = (items, fn) -> [ (fn item, index, items) for item, index in items ]

    {
      take, drop, split-at, head-and-tail,
      first, last,
      array-as-object, arrays-as-object,
      map
    }