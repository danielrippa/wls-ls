
  do ->

    { List } = dependency primitive.List
    { Tuple } = dependency primitive.Tuple
    { type-descriptor-as-string, type-error: MaybeList: PrimitiveMaybeList, is-a, primitive-type: p, type-error } = dependency primitive.Type
    { control-chars } = dependency native.String

    TupleList = (types-descriptor, value) ->

      List <[ List ]> value

      for tuple, index in value

        try Tuple types-descriptor, tuple
        catch => type-error "TupleList item at index #index error: '#{ e.message }'"

      value

    MaybeTupleList = (types-descriptor, value) ->

      PrimitiveMaybeList types-descriptor, value

      if value `is-a` p.List

        TupleList types-descriptor, value

      value

    { rs, us } = control-chars

    tuple-list-as-string = (tuple-list, types-descriptor = '...') ->

      TupleList types-descriptor, tuple-list

      string-list = []

      for tuple in tuple-list

        string-list.push tuple.join us

      string-list.join rs

    {
      TupleList,
      MaybeTupleList,
      tuple-list-as-string
    }