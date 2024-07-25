
  do ->

    { List, MaybeList, type-descriptor-as-string, type-name, isnt-a, is-a, primitive-type: p, type-error } = dependency primitive.Type
    { last-item, trunk-and-root } = dependency native.Array

    Tuple = (types-descriptor, elements) ->

      List elements

      types-descriptor = types-descriptor |> type-descriptor-as-string

      types = types-descriptor / ' '

      if (last-item types) is '...'
        [ types ] = trunk-and-root types

      for type, index in types

        element = elements[index]

        element-type = type-name element

        type-error "Tuple element [#{ type-name element }] #element at position #index must be a #type as per the tuple type definition '#types-descriptor'" \
          if element `isnt-a` type

      elements

    MaybeTuple = (types-descriptor, elements) ->

      MaybeList elements

      if elements `is-a` p.List

        Tuple elements

      elements

    {
      Tuple, MaybeTuple
    }