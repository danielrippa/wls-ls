
  do ->

    { camel-case } = dependency native.String

    take-items = (array, n) ->

      if n <= 0
        array.slice 0, 0
      else
        array.slice 0, n

    drop-items = (array, n) ->

      if n <= 0
        array
      else
        array.slice n

    split-at = (array, n) -> [ (take-items array, n), (drop-items array, n) ]

    head-and-tail = -> it `split-at` 1

    trunk-and-root = -> it `split-at` (it.length - 1)

    first-item = (array) -> if array.length is 0 then void else array.0

    last-item = (array) -> if array.length is 0 then void else array[* - 1]

    array-as-object = (array) -> { [ (camel-case value), (value) ] for value in array }

    arrays-as-object = (names, values) -> { [ (name), (values[index]) ] for name, index in names }

    map = (items, fn) -> [ (fn item, index, items) for item, index in items ]

    {
      take-items, drop-items,
      split-at, head-and-tail, trunk-and-root,
      first-item, last-item,
      array-as-object, arrays-as-object,
      map
    }