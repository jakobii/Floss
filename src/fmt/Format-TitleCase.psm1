FUNCTION Format-TitleCase  {
    param(
        [parameter(Mandatory = $true, ValueFromPipeline)]
        $InputObject,

        [switch]
        $DBNull
    )

    if(Test-Falsy $InputObject){ return Pop-Falsy -DBNull:$DBNull }
    
    [string]$string = $InputObject
    [string]$lowered = $string.tolower()
    [string]$trimmed = $lowered.Trim()

    $eng = [System.Globalization.CultureInfo]::new('en-US')
    [string]$OutputObject = $eng.TextInfo.ToTitleCase($trimmed)

    return Pop-Falsy $OutputObject -DBNull:$DBNull
}