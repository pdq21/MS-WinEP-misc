<#
    .SYNOPSIS
    Open specific filetypes with another program.
    .NOTES
    TODO
    Loops through all existing users and temp-mounted default user hive.
#>
$reg = @{
    FileTypes = @{
        ".hta" = "htafile"
        ".scr" = "SHCmdFile"
        ".sct" = "scriptletfile"
        ".vbs" = "VBSFile"
        ".wsf" = "WSFFile"
    }
    Path = "Registry::__ROOT__\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\__EXT__\"
    SubPaths = @{
        OpenWithProgids = @{
            Value = 0
            Type = "Binary"
        }
        UserChoice = @{
            Name = "Progid"
            Value = "Applications\\NOTEPAD.EXE"
            Type = "String"
        }
    }
}
#TODO