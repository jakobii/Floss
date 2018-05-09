FUNCTION Format-TitleCase  {
    param(
        [parameter(Mandatory = $true, ValueFromPipeline)]
        $InputObject
    )

    [string]$str = $InputObject
    [string]$lower = $str.tolower()
    [string]$trim = $lower.Trim()
    [string]$title = ToTitleCase = $eng.TextInfo.ToTitleCase($trim)

    if (test-falsy $title) {
        return $null
    } 
    else {
        return $title
    }
    
    return $InputObject
}