
  do ->

    { Bool } = dependency primitive.Type
    { List, StrList } = dependency primitive.List
    { Tuple } = dependency primitive.Tuple

    #

    clauses-as-string = (prefix, clauses) ->

      StrList clauses

      if clauses.length is 0
        ''
      else
        "#prefix #{ clauses * ', ' }"

    where-as-string = (clauses) -> clauses-as-string 'WHERE', clauses

    #

    group-by-as-string = (clauses) -> clauses-as-string 'GROUP BY', clauses

    #

    having-as-string = (clauses) -> clauses-as-string 'HAVING', clauses

    #

    order-by-as-string = (clauses) -> clauses-as-string 'ORDER BY', clauses

    #

    select-statement = (result-columns, from-clauses, where-clauses = [], order-by-clauses = [], distinct = no, group-by-clauses = [], having-clauses = []) ->

      Bool distinct ; StrList result-columns ; StrList from-clauses

      "SELECT #{ if distinct then 'DISTINCT' else '' } #{ result-columns * ', ' } FROM #{ from-clauses * ' ' } #{ where-as-string where-clauses } #{ group-by-as-string group-by-clauses } #{ having-as-string having-clauses } #{ order-by-as-string order-by-clauses }"

    #

    inner-join-as-string = (clause) ->

      Tuple <[ Str Str Str ]> clause

      [ table-alias, left-hand-field, right-hand-field ] = clause

      "INNER JOIN #table-alias ON #left-hand-field = #right-hand-field"

    #

    from-clauses-from-table-and-inner-join-clauses = (table-clauses, inner-join-clauses) ->

      StrList table-clauses ; List <[ List ]> inner-join-clauses

      table-clauses ++ [ (inner-join-as-string inner-join-clause) for inner-join-clause in inner-join-clauses ]

    #

    inner-join-statement = (result-columns, table-clauses, inner-join-clauses, where-clauses = [], order-by-clauses = [], distinct = no, group-by-clauses = [], having-clauses = []) ->

      from-clauses = from-clauses-from-table-and-inner-join-clauses table-clauses, inner-join-clauses

      select-statement result-columns, from-clauses, where-clauses, order-by-clauses, distinct, group-by-clauses, having-clauses

    {
      select-statement,
      inner-join-statement
    }