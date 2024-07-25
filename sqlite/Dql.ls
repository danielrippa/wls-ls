
  do ->

    { Str, Bool, MaybeStr } = dependency primitive.Type
    { List, StrList } = dependency primitive.List
    { Tuple } = dependency primitive.Tuple
    { where-as-string, group-by-as-string, having-as-string, order-by-as-string } = dependency sqlite.Clauses

    #

    from-as-string = (table-clause) ->

      MaybeStr table-clause

      if table-clause isnt void
        "FROM #table-clause"
      else
        ''

    #

    join-as-string = (join-clause) ->

      Tuple <[ Str Str Str ]> join-clause

      [ join-type, table-alias, join-conditions ] = join-clause

      "#join-type JOIN #table-alias ON #join-conditions"

    #

    select-statement = (result-columns, table-clause, join-clauses = [], where-clauses = [], order-by-clauses = [], distinct = no, group-by-clauses = [], having-clauses = []) ->

      StrList result-columns ; Str table-clause ; List <[ List ]> join-clauses ; Bool distinct

      table-reference-clauses = [ (join-as-string join-clause) for join-clause in join-clauses ]

      "SELECT #{ if distinct then 'DISTINCT' else '' } #{ result-columns * ', ' } #{ from-as-string table-clause } #{ table-reference-clauses * ' ' } #{ where-as-string where-clauses } #{ group-by-as-string group-by-clauses } #{ having-as-string having-clauses } #{ order-by-as-string order-by-clauses }"

    {
      select-statement
    }