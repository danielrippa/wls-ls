
  do ->

    { sqlite-exec } = dependency sqlite.Process
    { trim } = dependency native.String
    { StrList } = dependency primitive.List
    { last, map } = dependency native.Array
    { select-statement, inner-join-statement } = dependency sqlite.Dql
    { output-as-objects } = dependency sqlite.Output

    #

    semicolon = ';'

    sanitize-statement = (statement) ->

      chars = (trim statement) / ''

      if (last chars) isnt semicolon
        "#statement#semicolon"
      else
        statement

    #

    exec-statements = (db-filepath, statements, options) ->

      statements = (StrList statements) `map` sanitize-statement

      sqlite-exec db-filepath, statements, options

    ##

    new-database = (filepath) ->

      exec: (statements, options) -> exec-statements filepath, statements, options

      check-integrity: -> output = @exec [ 'PRAGMA integrity_check' ] ; (trim output) is 'ok'

      query: -> @exec [ it ], <[ header ]> |> output-as-objects

      select: (result-columns, from-clauses, distinct, where-clauses, group-by-clauses, having-clauses) ->

        @query select-statement result-columns, from-clauses, distinct, where-clauses, group-by-clauses, having-clauses

      inner-join: (result-columns, table-clause, inner-join-clauses, distinct, where-clauses, group-by-clauses, having-clauses) ->

        @query inner-join-statement result-columns, table-clause, inner-join-clauses, distinct, where-clauses, group-by-clauses, having-clauses

    {
      new-database
    }