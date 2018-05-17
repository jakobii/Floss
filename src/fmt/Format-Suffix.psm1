#beta


FUNCTION Format-Suffix {
    param(
        [parameter(Mandatory = $true, ValueFromPipeline)]
        [string]
        $InputObject
    )
    if (Test-Falsy $InputObject) { return $null }

    $eng = [System.Globalization.CultureInfo]::new('en-US')
    switch -Regex ([string]$InputObject) {
        
        # Sr | JR
        '[,. ]+?\b[JjSs][Rr]\b[,.]?$' {
            $regx = [regex]::new("^[A-Za-z.'-]+[,. ]+?\b")
            $str = $regx.Replace($InputObject, '')
            $str = $eng.TextInfo.ToTitleCase($str.tolower())
        }
        
        # Roman Numerals
        "^[A-Za-z.'-]+[,. ]+?[VvIi]{1,3}[,.]?$" {
            $regx = [regex]::new("^[A-Za-z.'-]+[,. ]+?(?=[IiVv]+)") 
            [string]$str = $regx.Replace($InputObject, '')
            $str = $eng.TextInfo.ToTitleCase($str)
        }
        
        # Scrub !@#$%^&*()
        "\W" {
            $regx = [regex]::new("\W")
            $OutputObject = $regx.Replace($str, '')
            break
        }
    }

    return Pop-Falsy $OutputObject
}


function Format-Suffix([string]$sfx) {
    $eng = [System.Globalization.CultureInfo]::new('en-US')
    switch -Regex ([string]$sfx) {
        # Sr | JR
        '[,. ]+?\b[JjSs][Rr]\b[,.]?$' {
            $regx = [regex]::new("^[A-Za-z.'-]+[,. ]+?\b")
            $str = $regx.Replace($sfx, '')
            $str = $eng.TextInfo.ToTitleCase($str.tolower())
        }
        # Roman Numerals
        "^[A-Za-z.'-]+[,. ]+?[VvIi]{1,3}[,.]?$" {
            $regx = [regex]::new("^[A-Za-z.'-]+[,. ]+?(?=[IiVv]+)") 
            [string]$str = $regx.Replace($sfx, '')
            $str = $eng.TextInfo.ToTitleCase($str)
        }
        # Scrub !@#$%^&*()
        "\W" {
            $regx = [regex]::new("\W")
            $str = $regx.Replace($str, '')
            break
        }
        default {return $null}
    }
    return $str 
}