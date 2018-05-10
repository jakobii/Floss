

# returns an array of [System.IO.DirectoryInfo] objects
# index 0 is the startin Directory 

FUNCTION ConvertTo-DirectoryInfoArray {
    Param(
        [parameter(Mandatory = $true, ValueFromPipeline)]
        [System.IO.DirectoryInfo]
        $Path
    )

    [array]$PathArray = @()
    [array]$PathArray += $Path
    $I = 0
    While($true){
        [System.IO.DirectoryInfo]$parent = $PathArray[$i].Parent
        [array]$PathArray += $parent
        $I++
        # Test Parent
        if($PathArray[$i].FullName -eq $Path.Root.FullName){
            break
        }
    }

    return $PathArray 
}