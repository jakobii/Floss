
FUNCTION Merge-Files ($Path, $Extension, [int]$depth) {
    
    
    # validate path
    if ( !$(Test-Path $Path) ) {
        write-fail "$(Get-FunctionName): Could Not Find Path"
        Return 
    }
    

    # Get all the items recursively
    $GetChildItem = @{}
    $GetChildItem.Path = $Path 
    $GetChildItem.Recurse = $true
    if($depth){$GetChildItem.depth = $depth}
    $ChildItems = Get-ChildItem @GetChildItem
    

    # only keep files
    [array]$items = @()
    foreach ($ChildItem in $ChildItems) {
        if ( !$($ChildItem -is [System.IO.DirectoryInfo]) ) {
            [array]$items += $ChildItem
        }
    }
    

    [array]$LINE_ARRAY = @()
    [array]$FILES = @()

    # choose files
    FOREACH ($item in $items) {

        # filter by extension
        if ($Extention -and $item.Extension -eq $Extension) {
            [array]$FILES += $item.fullname
            CONTINUE
        }

        # catch all
        if (!$Extention) {
            [array]$FILES += $item.fullname
            CONTINUE
        }
    }

    # Add file data to line array
    FOREACH ($FILE in $FILES) {
        [array]$FILE_ARRAY = Get-Content -Path $FILE

        #kinda funy logic here but we are just combining two arrays
        [array]$LINE_ARRAY += [array]$FILE_ARRAY 
    }
    
    RETURN $LINE_ARRAY
}