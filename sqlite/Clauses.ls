
  do ->

    { StrList } = dependency primitive.List

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

    {
      where-as-string,
      group-by-as-string,
      having-as-string,
      order-by-as-string
    }