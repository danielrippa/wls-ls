
  do ->

    { Str, Bool, MaybeStr } = dependency primitive.Type
    { List, StrList } = dependency primitive.List
    { Tuple } = dependency primitive.Tuple
    { where-as-string, group-by-as-string, having-as-string, order-by-as-string } = dependency sqlite.Clauses

    select-statement = (result-columns, table-reference-clauses, where-clauses = [], order-by-clauses = [], distinct = no, group-by-clauses = [], having-clauses = []) ->

      StrList result-columns ; StrList table-reference-clauses ; Bool distinct

      "SELECT #{ if distinct then 'DISTINCT' else '' } #{ result-columns * ', ' } #{ table-reference-clauses * ' ' } #{ where-as-string where-clauses } #{ group-by-as-string group-by-clauses } #{ having-as-string having-clauses } #{ order-by-as-string order-by-clauses }"

    #

    join-as-string = (join-clause) ->

      Tuple <[ Str Str Str ]> join-clause

      [ join-type, table-alias, join-conditions ] = join-clause

      "#join-type JOIN #table-alias ON #join-conditions"

    #

    from-as-string = (table-clause) ->

      MaybeStr table-clause

      if table-clause isnt void
        "FROM #table-clause"
      else
        ''

    join-statement = (result-columns, table-clause, join-clauses, where-clauses = [], order-by-clauses = [], distinct = no, group-by-clauses = [], having-clauses = []) ->

      List <[ List ]> join-clauses

      table-reference-clauses = [ from-as-string table-clause ] ++ [ (join-as-string join-clause) for join-clause in join-clauses ]

      select-statement result-columns, table-reference-clauses, where-clauses, order-by-clauses, distinct, group-by-clauses, having-clauses

    {
      select-statement,
      join-statement
    }