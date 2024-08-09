
  do ->

    object-from-arrays = (names, values) -> { [ name, values[index] ] for name, index in names }
    object-from-array  = (names)         -> { [ name, name ] for name in names }

    object-from-array-and-function = (array, fn) -> { [ (name), (fn name, index, array) ] for name, index in array }

    map-object-values = (object, fn) -> { [ (key),  (fn value, key, object) ] for key, value of object }
    map-object-keys   = (object, fn) -> { [ (fn key, value, object), (value) ] for key, value of object }

    map-object = (object, key-fn, value-fn) -> { [ (key-fn key, value, object), (value-fn value, key, object) ] for name, value of object }

    each-object = (object, fn) ->

      for name, value of object => fn name, value, object

      object

    fold-object = (object, memento, fn) ->

      for name, value of object => memento := fn memento, name, value, object

      memento

    object-keys = (object) -> [ (key) for key of object ]

    object-values = (object) -> [ (value) for , value of object ]

    object-as-array = (object, fn) -> [ (fn key, value, object) for key, value of object ]

    {
      object-from-arrays, object-from-array, object-from-array-and-function,
      map-object-values, map-object-keys, map-object,
      each-object, fold-object,
      object-keys, object-values,
      object-as-array
    }