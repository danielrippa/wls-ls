
  do ->

    { Str, Fieldset, Type } = dependency primitive.Type
    { first-chars, padl } = dependency native.String

    # https://learn.microsoft.com/en-us/previous-versions/windows/internet-explorer/ie-developer/scripting-articles/hww8txat(v=vs.84)

    new-filesystem = -> new ActiveXObject 'Scripting.FileSystemObject'

    fs = new-filesystem!

    drive-exists = -> fs.DriveExists Str it
    file-exists = -> fs.FileExists Str it
    folder-exists = -> fs.FolderExists Str it

    build-path = (path, name) -> fs.BuildPath (Str path), (Str name)

    parent-folder = -> fs.GetParentFolderName Str it

    delete-file = -> fs.DeleteFile Str it
    delete-folder = -> fs.DeleteFolder Str it

    new-folder = -> fs.GetFolder Str it

    new-folder-file = (folder-filepath, filename) -> new-folder (Str folder-filepath) |> (.Files Str filename)

    with-extension = (filepath, extension) ->

      Str filepath ; Str extension ;

      index = filepath.last-index-of '.'

      if index isnt -1

        "#{ first-chars filepath, index }.#extension"

    file-name = -> fs.GetFileName Str it

    filepath-as-file = (filepath) -> new-folder-file (parent-folder filepath), (file-name filepath)

    last-modified-as-ms = (filepath) -> filepath |> filepath-as-file |> (.DateLastModified * 1000)

    absolute-path = -> fs.GetAbsolutePathName Str it

    {
      new-filesystem,
      drive-exists, file-exists, folder-exists,
      build-path, parent-folder,
      delete-file, delete-folder,
      new-folder, new-folder-file,
      with-extension, file-name,
      filepath-as-file,
      last-modified-as-ms,
      absolute-path
    }