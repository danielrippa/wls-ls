
  do ->

    { new-shell } = dependency wsh.Shell
    { new-filesystem } = dependency wsh.FileSystem
    { camel-case } = dependency native.String

    shell = new-shell!

    fs = new-filesystem!

    folder-spec =

      windows: 0
      system: 1
      temporary: 2

    temporary = fs.GetSpecialFolder folder-spec.temporary .Path

    get-special-folder = -> shell.SpecialFolders it

    special-folder-names = <[
      public-desktop start-menu programs startup
      desktop roaming roaming-printers roaming-templates
      fonts
      roaming-network
      user-desktop
      roaming-start-menu
      roaming-sendto
      roaming-recent
      roaming-startup
      user-favorites user-documents
      roaming-programs
    ]>

    special-folders = { [ (camel-case name), (get-special-folder index) ] for name, index in special-folder-names }

    {
      public-desktop, start-menu, programs, startup, desktop, roaming, roaming-printers, roaming-templates,
      fonts, roaming-network, user-desktop, roaming-start-menu, roaming-sendto, roaming-recent, roaming-startup,
      user-favorites, user-documents, roaming-programs
    } = special-folders

    shell = new ActiveXObject 'Shell.Application'

    namespace = -> shell.Namespace it

    shell-folder-names = <[
      user-desktop
      internet
      user-roaming-programs
      control-panel
      printers
      user-documents
      user-favorites
      user-roaming-startup
      user-roaming-recent
      user-roaming-sendto
      recycle-bin
      user-roaming-start-menu
      unknown1
      user-music
      user-videos
      unknown2
      user-desktop
      this-pc
      network
      network-shortcuts
      fonts
      user-roaming-templates
      program-data-start-menu
      program-data-programs
      program-data-startup
      user-desktop
      user-roaming
      user-roaming-printer-shortcuts
      user-local
      user-roaming-startup
      program-data-startup
      user-favorites
      inet-cache inet-cookies
      history
      program-data
      windows
      system32
      program-files
      user-pictures
      user-profile
      syswow64
      program-files-x86
      common-files
      common-files-x86
      program-data-templates
      public-documents
      user-administrative-tools
      user-roaming-administrative-tools
    ]>

    namespace-path = -> namespace it .Self.Path

    shell-special-folders = {}

    for name, index in shell-folder-names

      path = void

      try path = namespace-path index

      shell-special-folders[name] = path

    {
      internet, control-panel, printers,
      recycle-bin,
      user-music, user-videos,
      this-pc, network,
      programdata-start-menu, program-data-programs, program-data-startup,
      appdata-local,
      programdata-startup,
      inet-cache, inet-cookies, history,
      program-data,
      windows,
      system32,
      program-files,
      user-pictures,
      syswow64,
      program-files-x86,
      common-files,
      common-filex-x86,
      programdata-templates,
      public-documents,
      user-administrative-tools,
      user-roaming-administrative-tools
    } = shell-special-folders

    {
      get-special-folder, special-folder-names,
      special-folders,

      temporary,

      public-desktop, start-menu, programs, startup, desktop, roaming, roaming-printers, roaming-templates,
      fonts, roaming-network, user-desktop, roaming-start-menu, roaming-sendto, roaming-recent, roaming-startup,
      user-favorites, user-documents, roaming-programs,

      internet, control-panel, printers,
      recycle-bin,
      user-music, user-videos,
      this-pc, network,
      programdata-start-menu, program-data-programs, program-data-startup,
      appdata-local,
      programdata-startup,
      inet-cache, inet-cookies, history,
      program-data,
      windows,
      system32,
      program-files,
      user-pictures,
      syswow64,
      program-files-x86,
      common-files,
      common-filex-x86,
      programdata-templates,
      public-documents,
      user-administrative-tools,
      user-roaming-administrative-tools
    }