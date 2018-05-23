Function Test-Falsy {
    param(
    
        # the value you would like to check for null
        [parameter(Mandatory = $true, ValueFromPipeline)]
        [AllowNull()]
        [alias("o")]    
        $InputObject, 
        
        # Causes this function to return false if $InputObject -eq <Some Null>
        [alias("af")]
        [switch]
        $asFalse, 
        
        [alias("v")]
        [switch]
        $Verbosely 
    ) 

    write-start -verbosely:$Verbosely
    
    [hashtable]$log = @{}
    $log.InputObject = $InputObject
    
    # false until proven true
    [boolean]$Falsy = $False
    

    # Null
    if ($InputObject -eq $null) {
        [boolean]$Falsy = $True
        $log.DataType = 'null'
    }
    else {
        $log.DataType = $InputObject.GetType()
    }



    # DBNull
    if ($InputObject -is [DBNull]) {
        [boolean]$Falsy = $True 
    }
    # int
    elseif ($InputObject -is [int]) {
        if ($InputObject -eq 0) {
            [boolean]$Falsy = $True
        }
    }
    # Float
    elseif ($InputObject -is [float]) {
        if ($InputObject -eq 0) {
            [boolean]$Falsy = $True
        }
    }
    # String
    elseif ($InputObject -is [String]) {
        $log.CharCount = $InputObject.count
        if ($InputObject.Trim() -eq '') {
            [boolean]$Falsy = $True
        }
    }
    # char
    elseif ($InputObject -is [char]) {
        if ($InputObject -eq ' ') {
            [boolean]$Falsy = $True
        }
    }
    # Standard powershell falsy catching
    elseif (!$InputObject) {
        [boolean]$Falsy = $True
    } 

    $log.Flasy = $Falsy
    Write-Note $log -Verbosely:$Verbosely
    write-end -verbosely:$Verbosely

    if ($AsFalse -eq $true) {
        Return !$Falsy
    }
    if ($AsFalse -eq $false) {
        Return $Falsy
    }
          
}
