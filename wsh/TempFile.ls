
  do ->

    { read } = dependency wsh.TextFile
    { temporary } = dependency wsh.SpecialFolders
    { new-filesystem, build-path, delete-file } = dependency wsh.FileSystem

    fs = new-filesystem!

    new-tempfile = ->

      filepath = build-path temporary, fs.GetTempName!

      filename: filepath

      consume: ->

        try content = read filepath ; delete-file filepath
        content

    {
      new-tempfile
    }