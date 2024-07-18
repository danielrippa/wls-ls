
  do ->

    { new-shell } = dependency wsh.Shell

    expand-vars = -> new-shell!ExpandEnvironmentStrings it

    {
      expand-vars
    }