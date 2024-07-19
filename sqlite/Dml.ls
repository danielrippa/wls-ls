
  do ->

    { Str } = dependency primitive.Type
    { where-as-string } = dependency sqlite.Clauses
    { List } = dependency primitive.List
    { Tuple } = dependency primitive.Tuple
    { single-quotes } = dependency native.String

    column-clauses-as-names-and-values = (column-clauses) ->

      List <[ List ]> column-clauses

      names = [] ; values = []

      for clause in column-clauses

        Tuple <[ Str Str ]> clause

        [ name, value ] = clause

        names.push single-quotes name
        values.push single-quotes value

      [ names, values ]

    insert-statement = (table-clause, column-clauses) ->

      Str table-clause

      [ column-names, column-values ] = column-clauses-as-names-and-values column-clauses

      "INSERT INTO #table-clause (#{ column-names * ',' }) VALUES (#{ column-values * ', ' }) RETURNING *"

    remove-statement = (table-clause, where-clauses) ->

      Str table-clause

      "DELETE FROM #table-clause #{ where-as-string where-clauses } RETURNING *"

    {
      insert-statement,
      remove-statement
    }