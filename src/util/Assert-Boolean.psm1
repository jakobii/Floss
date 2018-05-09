FUNCTION Assert-Boolean {
    param( 
        [parameter(Mandatory = $true, ValueFromPipeline)]
        $InputObject, 
        [bool]$Expect, 
        [string]$Tag
    )

    Write-Start
    $log = @{}
    $log.Tag = $Tag


    # success
    if ($Expect -eq $InputObject) {
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
    $log.InputObject = $InputObject

    if ($Success) {
        Write-Success $log 
    }
    else {
        Write-Fail $log
    }

    Write-End
}