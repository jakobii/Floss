function Protect-Sql($InputObject) {
    
    # array
    if ($InputObject -is [Array]) {
        [array]$OutputObject = @()
        foreach ($row in $InputObject) {
            $Escaped_Sql = Protect-Sql $row # [recurse] :D!
            [array]$OutputObject += $Escaped_Sql
        }
        return $OutputObject
    }

    # char
    if ($InputObject -is [char]) {
        if ($InputObject -eq "'") {
            return $null
        }
        return $InputObject
    }

    # String
    if ($InputObject -is [string])  {
        $Escaped_Sql = $InputObject -replace "'", "''"
        [string]$OutputObject = $Escaped_Sql
        return $OutputObject
    }

}
