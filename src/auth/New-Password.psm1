



Function New-Password ([int]$MinLength = 8 ) {
    
    DO {
        #GEN PASSWORD
        $Password = [System.Web.Security.Membership]::GeneratePassword( $MinLength, 2)

        # AD PASSWORD REQUIREMENTS
        $LENGTH  = [regex]::new(".{$MinLength,}").Match( $Password )
        $SPECIAL = [regex]::new('[!@#$%<>^&?]').Match( $Password )
        $LOWER   = [regex]::new('[a-z]').Match( $Password )
        $UPPER   = [regex]::new('[A-Z]').Match( $Password )
        $NUMBER  = [regex]::new('[0-9]').Match( $Password )
        
        # TEST PASSWORD
        $Meets_Complexity = $true
        if (!$LENGTH.Success)  {$Meets_Complexity = $false}
        if (!$SPECIAL.Success) {$Meets_Complexity = $false}
        if (!$LOWER.Success)   {$Meets_Complexity = $false}
        if (!$UPPER.Success)   {$Meets_Complexity = $false}
        if (!$NUMBER.Success)  {$Meets_Complexity = $false}
    }
    Until($Meets_Complexity)

    return $Password
}