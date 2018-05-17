





Function Import-Path($DB, [string]$Path, [boolean]$verbosely) {
    if ($verbosely) {Write-Start -message "Auto import" }
    #check if path exists
    if ($(Test-Path -Path $Path) -eq $false) { 
        if ($verbosely) {
            Write-Warning -Message "$Path could not be Found."
            Write-End "Auto import"
        }
        return 
    }

    #check if its file or folder
    $item = Get-Item -Path $Path
    if ($item.Attributes -eq 'Directory') {
        if ($verbosely) {Write-Note "Searching $Path for files to auto import" }
        $ImportFiles = Get-ChildItem -Path $Path -Recurse
        [boolean]$isDirectory = $true
    }
    if ($item.Attributes -eq 'Archive') {
        if ($verbosely) {Write-Note " Testing Path $Path" }
        [array]$ImportFiles = @($item)
        [boolean]$isDirectory = $False
    }
            
    #foreach
    [boolean]$ImportBoolean = $False
    
    foreach ($File in $ImportFiles) {
        #Get Item in more detail
        $item = Get-Item $File.PSPath
        #skip ignorefile
        if ($item.Name -eq '.ignore') {Continue}
        #check against ingnore file
        if ($verbosely) {Write-Note "checking file $($item.FullName) " }
        if ( $(search-IngnoreFile -value $item.Name -Folder $Folder) -and ($isDirectory -eq $true) ) {
            if ($verbosely) {
                Write-Note "$($item.Name) matches criteria in the '.ignore' file and will not be auto imported" 
            }
            continue
        }
        # default ignore list
        if ( search-DefaultIgnoreList -value $item.Name ) {
            if ($verbosely) {
                Write-Note "$($item.Name) matches criteria in the Default Ignore List and will not be auto imported" 
            }
            continue
        }
        
        #if csv
        if ( ($item.Extension).ToLower() -match ".csv") {
            $Data = import-csv -Path $item.FullName
            if (test-null $Data -AsFalse ) {[boolean]$ImportBoolean = $true}
            else {Write-Warning -Message " '$item' was not imported because it is an Empty file."}
        }
        #if txt
        if ( ($item.Extension).ToLower() -match ".txt") {
            $Data = import-csv -Path $item.FullName -Delimiter "`t"
            if (test-null $Data -AsFalse ) {[boolean]$ImportBoolean = $true}
            else {Write-Warning -Message " '$item' was not imported because it is an Empty file."}
        }

        #check if ok to import
        if ($ImportBoolean) {
            try {
                $TableName = $item.BaseName
                Remove-Table -TableName $TableName -DB $DB -verbosely $verbosely
                Import-Table -TableName $TableName -Value $Data -DB $DB -verbosely $verbosely
                if ($verbosely) {Write-Success -M  "$($item.FullName) was autoimported"}
            }
            catch { 
                throw $PSItem
            }
        }
    }
    if ($verbosely) {
        if ($ImportBoolean -eq $false) {
            Write-warning -Message "No Valid files where found for auto imported process" 
        }
        Write-End "Auto import"
    }
}