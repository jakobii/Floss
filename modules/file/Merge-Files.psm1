
FUNCTION Merge-Files ($Path, $Extension) {
    
    if( !$(Test-Path $Path) ){

        # [fix] error out

    }
    
    
    $items = Get-ChildItem -Path $Path
    
    
    
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
    FOREACH($FILE in $FILES){
        [array]$FILE_ARRAY = Get-Content -Path $FILE

        #kinda funy logic here but we are just combining two arrays
        [array]$LINE_ARRAY += [array]$FILE_ARRAY 
    }
    
    RETURN $LINE_ARRAY
}