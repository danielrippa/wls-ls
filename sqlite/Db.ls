
  do ->

    { sqlite-exec } = dependency sqlite.Process
    { trim, last-chars } = dependency native.String
    { StrList } = dependency primitive.List
    { map } = dependency native.Array
    { select-statement } = dependency sqlite.Dql
    { output-as-objects } = dependency sqlite.Output
    { debug } = dependency wsh.IO
    { remove-statement, insert-statement } = dependency sqlite.Dml

    #

    semicolon = ';'

    sanitize-statement = (statement) ->

      statement = trim statement

      if (last-chars statement) isnt semicolon
        "#statement#semicolon"
      else
        statement

    #

    exec-statements = (db-filepath, statements, options) ->

      statements = (StrList statements) `map` sanitize-statement

      for statement in statements => debug statement

      sqlite-exec db-filepath, statements, options

    ##

    new-database = (filepath) ->

      exec: (statements, options) -> exec-statements filepath, statements, options

      check-integrity: -> output = @exec [ 'PRAGMA integrity_check' ] ; (trim output) is 'ok'

      query: -> @exec [ it ], <[ header ]> |> output-as-objects

      select: (result-columns, table-clause, join-clauses, where-clauses = [], order-by-clauses = [], distinct = no, group-by-clauses = [], having-clauses = []) ->

        @query select-statement result-columns, table-clause, join-clauses, where-clauses, order-by-clauses, distinct, group-by-clauses, having-clauses

      insert: (table-clause, columns-clause) ->

        @query insert-statement table-clause, columns-clause

      remove: (table-clause, where-clauses) ->

        @query remove-statement table-clause, where-clauses

    {
      new-database
    }