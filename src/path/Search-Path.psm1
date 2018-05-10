
# return the closest path that matches
FUNCTION Find-Directory {
    param(
        [string]
        $DirectoryName,

        [System.IO.DirectoryInfo]
        $StartIn ,

        [ValidateSet("Child", "Parent")]
        [string]
        $type = 'Parent'
    )
    
    # Starting Directory
    if ($StartIn -eq $null) {
        $stack = $(Get-PSCallStack)[1]
        [System.IO.FileInfo]$Function = $stack.Position.File
        $StartIn = $Function.Directory
    }


    if ($type -eq 'Child') {}


    # Parent Directory
    if ($type -eq 'Parent') {
        $DirectoryInfoArray = ConvertTo-DirectoryInfoArray $StartIn
        Foreach ( $Directory in $DirectoryInfoArray ) {
            If ($Directory.Name -eq $DirectoryName) {
                Return $Directory
            }
        } 
    }
}
