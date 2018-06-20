




# by default 'A' and 'a' are NOT the same

FUNCTION Out-Unique {
    param(
        [parameter(Mandatory = $true, ValueFromPipeline)]
        [array]
        $InputObject,

        [switch]
        $Verbosely,

        [switch]
        $CaseInsensitive
    )

    $start = Write-Start -OutTime


    [array]$UniqueObjects = @()


    if ($CaseInsensitive) {
        foreach ($index in $InputObject) {
            if ($UniqueObjects -notcontains $index) {
                [array]$UniqueObjects += $index
            }
        }
    }

    if (!$CaseInsensitive) {
        foreach ($index in $InputObject) {
            if ($UniqueObjects -cnotcontains $index) {
                [array]$UniqueObjects += $index
            }
        }
    }

    $log = @{}
    $log.Recieved_Objects = $InputObject.Count
    $log.Unique_Objects = $UniqueObjects.Count


    Write-Note $log
    write-end -StartTime $start
    return $UniqueObjects 
}





