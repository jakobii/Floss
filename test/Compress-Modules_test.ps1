import-module "$PSScriptRoot\..\src\util\Compress-Modules.psm1"
 
$Sources = @(
    #'C:\Users\jacob.ochoa\Projects\Aeries\src'
    'C:\Users\jacob.ochoa\Projects\Inquiry\src'
    #'C:\Users\jacob.ochoa\Projects\DBWH\src'
    #'C:\Users\jacob.ochoa\Projects\adi\src'
)

Compress-Modules -Sources $Sources -destination "C:\Users\jacob.ochoa\Projects\Inquiry\inquiry.min.psm1" -version '1.0.0' -Name 'Inquiry'



