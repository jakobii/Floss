



function Get-FunctionName ([int]$CallStack = 1) {
    [string]$FunctionName = $(Get-PSCallStack)[$CallStack].FunctionName
    return $FunctionName
}







