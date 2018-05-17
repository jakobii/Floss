<# this imports everything in the modules folder
 # if a module has the '#beta' tag in the first 
 # line it will NOT be imported.
 #>

 # Get all the things
[array]$items = Get-ChildItem "$PSScriptRoot\src" -Recurse
foreach( $item in $items) {

   
    # filter the modules
    if($item.Extension -eq '.psm1'){
        [array]$lines = Get-Content -ReadCount 1 -Path $item.FullName
        
        # skip empty files
        if($lines -eq $null ){continue} 
        
        
        # ignore beta modules
        if($lines[0].Trim() -ne '#beta'){
            
            # import!
            import-module $item.FullName
        }
    }
}






