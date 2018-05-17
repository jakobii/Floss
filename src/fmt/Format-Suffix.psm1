

FUNCTION Format-Suffix {
    param(
        [parameter(Mandatory = $true, ValueFromPipeline)]
        [string]
        $InputObject
    )
    if (Test-Falsy $InputObject) { return $null }

    $eng = [System.Globalization.CultureInfo]::new('en-US')
    switch -Regex ($InputObject) {

        # Sr | JR
        '\b[JjSs][Rr]\b' {
            $regx = [regex]::new("\b([JjSs][Rr])\b")
            $match = $regx.match($InputObject)
            [STRING]$Suffix = $match.Groups[1].Value.ToLower()
            break
        }
        
        # Roman Numerals 1-13
        "\b(I{1,3}|I{0,3}XI{0,3}|I{0,3}VI{0,3})\b" {
            $regx = [regex]::new("\b(I{1,3}|I{0,3}XI{0,3}|I{0,3}VI{0,3})\b") 
            $match = $regx.match($InputObject)
            [STRING]$Suffix = $match.Groups[1].Value
            break
        }
    }

    if ($Suffix) {
        [string]$OutputObject = $eng.TextInfo.ToTitleCase( $Suffix )
        return $OutputObject
    }
}
