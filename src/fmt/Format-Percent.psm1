#beta

FUNCTION Format-Percent {
    param(
        [parameter(Mandatory = $true, ValueFromPipeline)]
        $InputObject,

        [switch]
        $DBNull
    )
    if(Test-Falsy $InputObject){ return Pop-Falsy -DBNull:$DBNull }

    return Pop-Falsy $InputObject -DBNull:$DBNull
}