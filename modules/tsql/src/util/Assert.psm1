
FUNCTION Assert-String($Value, [string]$Expect, [string]$Tag) {
    
    # Get Type
    $type = $Value.gettype()
    
    # Get Length
    try {
        $R_length = $Value.length
    }
    catch {
        $R_length = 'N/A' 
    }

    # Get-Host Formatting 
    if ($Value -eq $Expect) {
        $color = 'Green'
        $Success = $true
    }
    else {
        $color = 'Red'
        $Success = $false
    }

    
    #Tag
    if($Tag){
        $Tag_Show = ": $Tag"
    }
    else{
        $Tag_Show = $null
    }


    # Write-Host
    Write-Host ''
    Write-Host -b $color -Object " Assert-String $Tag_Show " -f 'Black'
    Write-Host -f $color -Object "Success  : $Success"
    Write-Host -f $color -Object "Expected : $Expect"
    Write-Host -f $color -Object "Received : $Value"
    Write-Host -f $color -Object "E length : $($Expect.length)"
    Write-Host -f $color -Object "R length : $R_length"
    write-host -f $color -Object "TypeName : $($type.Name)"
    write-host -f $color -Object "TypeBase : $($type.BaseType.Name)"

}



