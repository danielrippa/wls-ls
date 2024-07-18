
  do ->

    { read } = dependency wsh.TextFile
    { temporary } = dependency wsh.SpecialFolders
    { new-filesystem, build-path, delete-file } = dependency wsh.FileSystem
    { debug } = dependency wsh.IO

    fs = new-filesystem!

    new-tempfile = ->

      filepath = build-path temporary, fs.GetTempName!

      filename: filepath

      consume: ->

        try content = read filepath ; delete-file filepath
        catch => debug "wsh.TempFile.new-tempfile.consume #{ @filename }" ; debug e.message

        content

    {
      new-tempfile
    }