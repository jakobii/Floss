




FUNCTION Assert-type {
    PARAM(
        [parameter(Mandatory = $true, ValueFromPipeline)]
        [AllowNull()]
        [AllowEmptyString()]
        $InputObject, 

        [AllowNull()]
        $Expect, 
        
        [string]
        $Tag
    )

    Write-Start
    Write-Alert $Tag
    $log = @{}

    # Success 
    [string]$type = $InputObject.GetType()

    if ( $type -eq $Expect ){
        $Success = $true
    }
    else {
        $Success = $false
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










