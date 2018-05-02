



function Get-FunctionName ([int]$CallStack = 1) {
    $FunctionName = $(Get-PSCallStack)[$CallStack].FunctionName
    return $FunctionName
}







