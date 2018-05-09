


FUNCTION Format-PhoneNumber {
    param(
        [parameter(Mandatory = $true, ValueFromPipeline)]
        $InputObject
    )

    # Check if the Value has numbers in it
    # if it does not contain numbers return null
    [bool]$Contains_Int = $InputObject -match '.*\d.*'
    if (!$Contains_Int) {return $null}

    # safely convert to string else null
    try {[string]$PhoneNumber_Orginal = $InputObject}
    catch {Return $null}

    #[array]$CharArray = $PhoneNumber_Orginal.ToCharArray()
    foreach ($char in $PhoneNumber_Orginal.ToCharArray() ) {
        if ($char -match '\d') {
            #[string]$str = $char
            [string]$PhoneNumber_Int_Only += $char
        }
    }

    # Format Numbers According to digit count in regex
    Switch -Regex ($PhoneNumber_Int_Only) {
        
        # Short Formatted PhoneNumber : ddd-dddd
        '^(\d{3})(\d{4})$' {
            $Regex = [regex]::new('^(\d{3})(\d{4})$')
            $Match = $Regex.Match($PhoneNumber_Int_Only)
            [string]$g1 = $Match.Groups[1].Value
            [string]$g2 = $Match.Groups[2].Value
            [string]$PhoneNumber_Formatted = "$g1-$g2"
            break
        }

        # Formatted PhoneNumber with Area code : (ddd) ddd-dddd
        '^(\d{3})(\d{3})(\d{4})$' {
            $Regex = [regex]::new('^(\d{3})(\d{3})(\d{4})$')
            $Match = $Regex.Match($PhoneNumber_Int_Only)
            [string]$g1 = $Match.Groups[1].Value
            [string]$g2 = $Match.Groups[2].Value
            [string]$g3 = $Match.Groups[3].Value
            [string]$PhoneNumber_Formatted = "($g1) $g2-$g3"
            break
        }

        # Formatted PhoneNumber with 1-3 digit Country code : +ddd (ddd) ddd-dddd
        '^(\d{1,3})(\d{3})(\d{3})(\d{4})$' {
            $Regex = [regex]::new('^(\d{1,3})(\d{3})(\d{3})(\d{4})$')
            $Match = $Regex.Match($PhoneNumber_Int_Only)
            [string]$g1 = $Match.Groups[1].Value
            [string]$g2 = $Match.Groups[2].Value
            [string]$g3 = $Match.Groups[3].Value
            [string]$g4 = $Match.Groups[4].Value
            [string]$PhoneNumber_Formatted = "+$g1 ($g2) $g3-$g4"
            break
        }
        
        # Non-formatted PhoneNumber
        # Digit Length did not meet any standard
        default {
            [string]$PhoneNumber_Formatted = $PhoneNumber_Int_Only.trim()
            break
        }
    }

    return [string]$PhoneNumber_Formatted
}










