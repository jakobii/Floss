Import-Module $PSScriptRoot\..\PSDTK.psm1




$basic = {
 
    import-module .\..\PSDTK.psm1

}





Invoke-AsAdmin -Command $basic 


