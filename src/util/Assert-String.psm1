<# this function check if the InputObject param matches the expect param
 # the InputObject param is left duck typed on purpose. this allows for
 # the type provided to be out in a log. and prevents the type from 
 # being converted to a string and giving a false positive.
 #>
FUNCTION Assert-String {
    PARAM(
        [parameter(Mandatory = $true, ValueFromPipeline)]
        [AllowNull()]
        [AllowEmptyString()]
        $InputObject, 

        [AllowNull()]
        $Expect, 
        
        [string]
        $Tag,
        
        [switch]
        $CaseInSensitive
    )
    
    Write-Start
    Write-Alert $Tag
    $log = @{}

    # Success 
    if ( (!$CaseInSensitive -and $InputObject -ceq $Expect) -or ($CaseInSensitive -and $InputObject -eq $Expect) ){
        $Success = $true
    }
    else {
        $Success = $false
    }

    # Length
    try {
        $log.length = $InputObject.length
    }
    catch {
        $log.length = 'N/A' 
    }

    #type 
    if ($InputObject -eq $null ) {
        $log.Datatype = 'null'
    }
    else {
        $log.DataType = $InputObject.GetType()
        $log.TypeBase = $($InputObject.GetType()).BaseType.Name
    }

    
    $log.Success = $Success
    $log.Expected = $Expect
    $log.InputObeject = $InputObject

    if ($Success) {
        Write-Success $log 
    }
    else {
        Write-Fail $log
    }

    Write-End

}



