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
        $Verbosely,

        # assumes you intend to do a thorough check of complex
        # objects unless explicitly stated otherwise
        [switch]
        $fast 
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

    # Arrays
    elseif ($InputObject -is [array]) {
        try {
            # try to can stringify the array. 
            # faster then iterating and falsy's objects that are empty.
            [string]$ConcatArray = $InputObject[0..$($InputObject.Count - 1)]
            [boolean]$Falsy = test-falsy $ConcatArray
        }
        catch { 
            # dont error out
        }

        # Deep checking. this could take a while.....
        if (!$fast -and !$Falsy) {
            [boolean]$Falsy = $true # until proven false
            foreach ($index in $InputObject) {
                if (test-falsy $index -af) {
                    [boolean]$Falsy = $false
                    break # stop check at first non-falsy value
                }
            }
        }
    }
    # hashtables & OrderedDictionary
    elseif ($InputObject -is [hashtable] -or $InputObject -is [System.Collections.Specialized.OrderedDictionary]) {
        try {
            # try to can stringify the array. 
            # faster then iterating and falsy's objects that are empty.
            [string]$ConcatArray = $InputObject.values
            [boolean]$Falsy = test-falsy $ConcatArray
        }
        catch { 
            # dont error out
        }

        if (!$fast -and !$Falsy) {
            [boolean]$Falsy = $true # until proven false
            foreach($key in $InputObject.keys){
                $value = $InputObject.$key 
                if(test-falsy $value -af){
                    [boolean]$Falsy = $false
                    break # stop check at first non-falsy value
                }
            }
        }
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
