


function Get-Function {
    param(
        [int]
        $CallStack = 1
    )
        
    $Function = $(Get-PSCallStack)[$CallStack]

    $Item = get-item $Function.Position.File

    [hashtable]$FunctionInfo = @{
        FunctionName  = $Function.FunctionName
        ScriptBlock   = $Function.InvocationInfo.MyCommand.ScriptBlock
        FullName      = $Item.FullName
        FileName      = $Item.Name
        Directory     = $Item.Directory
        DirectoryName = $Item.DirectoryName
        Parameters    = [hashtable]$Function.InvocationInfo.BoundParameters
        
    }

    return $FunctionInfo
}


