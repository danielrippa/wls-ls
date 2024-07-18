
  do ->

    { List: PrimitiveList, MaybeList: PrimitiveMaybeList, type-descriptor-as-string, type-error, is-a, isnt-a, primitive-type: p, type-name } = dependency primitive.Type

    List = (item-type-descriptor, list) ->

      item-type-name = item-type-descriptor |> type-descriptor-as-string

      PrimitiveList list

      for item, index in list

        type-error "List item #item at index #index is not a #item-type-name" \
          if item `isnt-a` item-type-name

      list

    MaybeList = (item-type-descriptor, list) ->

      PrimitiveMaybeList list

      if list is-a p.List

        List item-type-descriptor, list

      list

    StrList = -> List <[ Str ]> it

    MaybeStrList = -> MaybeList <[ Str ]> it

    NumList = -> List <[ Num ]> it

    MaybeNumList = -> MaybeList <[ Num ]> it

    BoolList = -> List <[ Bool ]> it

    MaybeBoolList = -> MaybeList <[ Bool ]> it

    FnList = -> List <[ Fn ]> it

    MaybeFnList = -> MaybeList <[ Fn ]> it

    FieldsetList = -> List <[ Fieldset ]> it
    MaybeFieldsetList = -> MaybeList <[ Fieldset ]> it

    {
      List, MaybeList,
      StrList, MaybeStrList,
      NumList, MaybeNumList,
      BoolList, MaybeBoolList,
      FnList, MaybeFnList,
      FieldsetList, MaybeFieldsetList
    }