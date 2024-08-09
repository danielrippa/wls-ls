
  do ->

    { camel-case } = dependency native.String

    item-count = (array) -> array.length

    no-items = (array)  -> (item-count array) is 0

    has-items = (array) -> (item-count array) isnt 0

    filter-items = (array, fn) -> [ (item) for item, index in array when fn item, index, array ]

    reject-items = (array, fn) -> [ (item) for item, index in array when not fn item, index, array ]

    take-first-items = (array, n) ->

      if n <= 0
        array.slice 0, 0
      else
        array.slice 0, n

    drop-first-items = (array, n) ->

      if n <= 0
        array
      else
        array.slice n

    split-array-at = (array, n) -> [ (take-first-items array, n), (drop-first-items array, n) ]

    take-last-items = (array, n) ->

      if n <= 0
        array
      else
        array.slice -n

    drop-last-items = (array, n) ->

      if n <= 0
        array
      else
        array.slice 0, -n

    first-item = (array) -> if array.length is 0 then void else array.0

    last-item = (array) -> if array.length is 0 then void else array[* - 1]

    array-as-object = (array) -> { [ (camel-case value), (value) ] for value in array }

    arrays-as-object = (names, values) -> { [ (name), (values[index]) ] for name, index in names }

    map-items = (items, fn) -> [ (fn item, index, items) for item, index in items when (fn item, index, items)? ]

    item-index = (items, value) ->

      for item, index in items
        if value is item
          return index

      -1

    item-indices = (items, value) -> [ (index) for item, index in items when item is value ]

    find-index = (items, fn) ->

      for item, index in items
        if fn item, index, items
          return index

      -1

    find-indices = (items, fn) -> [ (index) for item, index in items when fn item, index, items ]

    each-item = (array, fn) ->

      for item, index in array

        # if (fn item, index, array)?
        #  return array

        fn item, index, array

      array

    fold-array = (array, memento, fn) ->

      for value, index in array => memento := fn memento, value, index, array

      memento

    unfold-array = (seed, fn) ->

      # builds a list from a seed
      # it takes a function which either returns null if it is done producing values for the list
      # or returns [ x, y ],
      # x is added to the list
      # y is used as the next element in the recursive call

      array = []
      item = seed

      while (fn item, array.length, array, seed)?

        array.push that.0
        item = that.1

      array

    repeat-item = (item, n) -> [ (item) til n ]

    contains-item = (array, item) -> (array `item-index` item) isnt -1

    {
      item-count, no-items, has-items,
      filter-items, reject-items,
      take-first-items, drop-first-items, take-last-items, drop-last-items,
      split-array-at,
      first-item, last-item,
      array-as-object, arrays-as-object,
      map-items,
      item-index, item-indices,
      find-index, find-indices,
      each-item,
      fold-array, unfold-array,
      repeat-item,
      contains-item
    }