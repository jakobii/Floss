<# this function check if the InputObject param matches the expect param
 # the InputObject param is left duck typed on purpose. this allows for
 # the type provided to be out in a log. and prevents the type from 
 # being converted to a string and giving a false positive.
 #>
FUNCTION Assert-String($InputObject, [string]$Expect, [string]$Tag) {

    Write-Start
    $log = @{}
    $log.Tag = $Tag
    

    # Success 
    if ($InputObject -eq $Expect) {
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
    if($InputObject -eq $null ){
        $log.Datatype = 'null'
    }
    else{
        $log.DataType = $InputObject.GetType()
        $log.TypeBase = $($InputObject.GetType()).BaseType.Name
    }

    
    $log.Success  = $Success
    $log.Expected = $Expect
    $log.InputObeject = $InputObject

    if($Success){
        Write-Success $log 
    }
    else{
        Write-Fail $log
    }

    Write-End

}



