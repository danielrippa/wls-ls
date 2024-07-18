
  do ->

    { Str } = dependency primitive.Type

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

    {
      new-filesystem,
      drive-exists, file-exists, folder-exists,
      build-path, parent-folder,
      delete-file, delete-folder
    }